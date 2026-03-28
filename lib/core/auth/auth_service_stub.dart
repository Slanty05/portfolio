import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._auth);

  // Kept for interface parity across platforms.
  // ignore: unused_field
  final FirebaseAuth _auth;

  @override
  Future<UserCredential> signInWithGoogle() {
    throw UnsupportedError('Google sign-in not supported on this platform');
  }
}

