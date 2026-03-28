import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service_stub.dart'
    if (dart.library.io) 'auth_service_io.dart'
    if (dart.library.html) 'auth_service_web.dart';

abstract interface class AuthService {
  Future<UserCredential> signInWithGoogle();
}

AuthService createAuthServiceForAuth(FirebaseAuth auth) => AuthServiceImpl(auth);

