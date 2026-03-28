import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import 'profile_repository.dart';

final cvUrlProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(storageProvider);
  final profile = await ref.watch(profileProvider.future);

  // Prefer explicit URL from Firestore (useful if you host elsewhere).
  if (profile.cvUrl != null && profile.cvUrl!.trim().isNotEmpty) {
    return profile.cvUrl!.trim();
  }

  // Otherwise, fetch from Storage using a convention-based path.
  // Put your PDF at `gs://<bucket>/cv/latest.pdf` (or update profile.cvUrl).
  const fallbackPath = 'cv/latest.pdf';
  try {
    final refObj = storage.ref(fallbackPath);
    return await refObj.getDownloadURL();
  } on FirebaseException {
    return null;
  }
});

