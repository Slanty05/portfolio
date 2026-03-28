import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<FirebaseApp> initialize({
    required FirebaseOptions options,
  }) async {
    try {
      return await Firebase.initializeApp(options: options);
    } on FirebaseException catch (e) {
      // Happens in hot restart / multi-init scenarios.
      if (e.code == 'duplicate-app') {
        return Firebase.app();
      }
      rethrow;
    }
  }
}

