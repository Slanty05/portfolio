import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import 'models/experience_model.dart';
import '../domain/experience_item.dart';

final experienceRepositoryProvider = Provider<ExperienceRepository>((ref) {
  return ExperienceRepository(firestore: ref.watch(firestoreProvider));
});

final experienceProvider = StreamProvider<List<ExperienceItem>>((ref) {
  final repo = ref.watch(experienceRepositoryProvider);
  return repo.watchExperience();
});

final experienceModelsProvider = StreamProvider<List<ExperienceModel>>((ref) {
  final repo = ref.watch(experienceRepositoryProvider);
  return repo.watchExperienceModels();
});

class ExperienceRepository {
  ExperienceRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<ExperienceItem>> watchExperience() {
    final query = _firestore.collection('portfolio_experience');

    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return const <ExperienceItem>[];
      final items = snap.docs.map(_fromDoc).toList(growable: false);
      items.sort((a, b) => a.order.compareTo(b.order));
      return items;
    });
  }

  Stream<List<ExperienceModel>> watchExperienceModels() {
    final query = _firestore.collection('portfolio_experience');
    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return const <ExperienceModel>[];
      final items = snap.docs
          .map((d) => ExperienceModel.fromMap(d.id, d.data()))
          .toList(growable: false);
      items.sort((a, b) => a.id.compareTo(b.id));
      return items;
    });
  }

  Future<void> upsertExperience(ExperienceItem item) async {
    final ref = _firestore.collection('portfolio_experience').doc(item.id);
    final model = ExperienceModel(
      id: item.order,
      companyId: item.id,
      companyName: item.company,
      companyLogo: '',
      role: item.role,
      period: item.period,
      highlights: item.bullets,
    );
    await ref.set(
      {
        ...model.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> deleteExperience(String id) async {
    await _firestore.collection('portfolio_experience').doc(id).delete();
  }

  ExperienceItem _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final model = ExperienceModel.fromMap(doc.id, doc.data());
    return ExperienceItem(
      id: doc.id,
      company: model.companyName,
      role: model.role,
      period: model.period,
      order: model.id,
      bullets: model.highlights,
    );
  }

  // No fallback data: portfolio is Firebase-driven.
}

