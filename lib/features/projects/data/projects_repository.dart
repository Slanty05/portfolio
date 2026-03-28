import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import 'models/project_model.dart';
import '../domain/project_item.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepository(firestore: ref.watch(firestoreProvider));
});

final projectsProvider = StreamProvider<List<ProjectItem>>((ref) {
  final repo = ref.watch(projectsRepositoryProvider);
  return repo.watchProjects();
});

final projectModelsProvider = StreamProvider<List<ProjectModel>>((ref) {
  final repo = ref.watch(projectsRepositoryProvider);
  return repo.watchProjectModels();
});

class ProjectsRepository {
  ProjectsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<ProjectItem>> watchProjects() {
    final query = _firestore.collection('portfolio_projects');

    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return const <ProjectItem>[];
      final items = snap.docs.map(_fromDoc).toList(growable: false);
      items.sort((a, b) => a.order.compareTo(b.order));
      return items;
    });
  }

  Stream<List<ProjectModel>> watchProjectModels() {
    final query = _firestore.collection('portfolio_projects');
    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return const <ProjectModel>[];
      final items = snap.docs
          .map((d) => ProjectModel.fromMap(d.id, d.data()))
          .toList(growable: false);
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<void> upsertProject(ProjectItem item) async {
    final ref = _firestore.collection('portfolio_projects').doc(item.id);
    final model = ProjectModel(
      id: item.order,
      title: item.title,
      category: '',
      logo: '',
      client: '',
      relatedCompanyId: '',
      description: [item.description],
      techIds: item.tags,
      stackUrl: const StoreUrls(
        appleStoreUrl: '',
        googlePlayStoreUrl: '',
      ),
    );
    await ref.set(
      {
        ...model.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> deleteProject(String id) async {
    await _firestore.collection('portfolio_projects').doc(id).delete();
  }

  ProjectItem _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final model = ProjectModel.fromMap(doc.id, doc.data());
    final descriptionText = model.description.join(' ');
    return ProjectItem(
      id: doc.id,
      title: model.title,
      description: descriptionText.isEmpty ? model.category : descriptionText,
      order: model.id,
      tags: model.techIds,
      repoUrl:
          model.stackUrl.googlePlayStoreUrl.isEmpty ? null : model.stackUrl.googlePlayStoreUrl,
      liveUrl: model.stackUrl.appleStoreUrl.isEmpty ? null : model.stackUrl.appleStoreUrl,
    );
  }

  // No fallback data: portfolio is Firebase-driven.
}

