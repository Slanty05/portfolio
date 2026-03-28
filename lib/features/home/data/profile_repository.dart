import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import 'models/profile_model.dart';
import '../domain/profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

final profileProvider = StreamProvider<Profile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.watchProfile();
});

class ProfileRepository {
  ProfileRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<Profile> watchProfile() {
    final ref = _firestore.collection('portfolio_info').doc('user');
    return ref.snapshots().map((snap) {
      final data = snap.data();
      if (data == null) {
        throw StateError(
          'Missing Firestore document: portfolio_info/user. Create it from Admin panel or Firebase Console.',
        );
      }
      final model = ProfileModel.fromMap(data);
      return Profile(
        name: model.fullName,
        title: model.jobTitle,
        summary: model.summary,
        location: model.location,
        email: model.email,
        phone: model.phoneNumber,
        linkedinUrl: model.linkedinUrl.isEmpty ? null : model.linkedinUrl,
        githubUrl: model.githubUrl.isEmpty ? null : model.githubUrl,
        cvUrl: model.resumeUrl.isEmpty ? null : model.resumeUrl,
      );
    });
  }

  Future<void> upsertProfile(Profile profile) async {
    final ref = _firestore.collection('portfolio_info').doc('user');
    final model = ProfileModel(
      fullName: profile.name,
      jobTitle: profile.title,
      email: profile.email,
      phoneNumber: profile.phone,
      summary: profile.summary,
      location: profile.location,
      linkedinUrl: profile.linkedinUrl ?? '',
      githubUrl: profile.githubUrl ?? '',
      resumeUrl: profile.cvUrl ?? '',
      imgUrl: '',
    );
    await ref.set(
      {
        ...model.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  // No fallback data: portfolio is Firebase-driven.
}

