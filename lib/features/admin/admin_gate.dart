import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';

/// Change this to your real admin email(s).
///
/// Best practice for production: enforce this in Firestore/Storage security rules.
const adminEmails = <String>{
  'mabakaro02@gmail.com',
};

/// Optional hardening: add your Firebase Auth UID(s) here too.
/// This is more reliable than email in the long term.
const adminUids = <String>{
  // 'YOUR_UID_HERE',
};

final isAdminProvider = Provider<bool>((ref) {
  final auth = ref.watch(authStateProvider);
  final user = auth.valueOrNull;
  if (user == null) return false;
  final email = user.email?.toLowerCase();
  return (email != null && adminEmails.contains(email)) || adminUids.contains(user.uid);
});

