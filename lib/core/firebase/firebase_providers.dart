import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAppProvider = Provider<FirebaseApp>((ref) {
  throw UnimplementedError('firebaseAppProvider must be overridden at startup');
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  final app = ref.watch(firebaseAppProvider);
  return FirebaseFirestore.instanceFor(app: app);
});

final storageProvider = Provider<FirebaseStorage>((ref) {
  final app = ref.watch(firebaseAppProvider);
  return FirebaseStorage.instanceFor(app: app);
});

