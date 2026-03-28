import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..addScope('email')
      ..addScope('profile');
    return _auth.signInWithPopup(provider);
  }
}

