import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import 'models/skill_model.dart';

final skillsRepositoryProvider = Provider<SkillsRepository>((ref) {
  return SkillsRepository(firestore: ref.watch(firestoreProvider));
});

final skillsProvider = StreamProvider<List<SkillModel>>((ref) {
  final repo = ref.watch(skillsRepositoryProvider);
  return repo.watchSkills();
});

class SkillsRepository {
  SkillsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<SkillModel>> watchSkills() {
    final query = _firestore.collection('portfolio_skills');

    return query.snapshots().map((snap) {
      if (snap.docs.isEmpty) return const <SkillModel>[];
      final items = snap.docs.map((doc) {
        final data = doc.data();
        final category = (data['category'] as String?)?.trim();
        return SkillModel.fromMap({
          ...data,
          'category': (category == null || category.isEmpty) ? doc.id : category,
        });
      }).toList(growable: false);

      items.sort((a, b) => a.category.toLowerCase().compareTo(b.category.toLowerCase()));
      return items;
    });
  }
}

