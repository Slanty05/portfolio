import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../firebase_options.dart';
import '../firebase/firebase_initializer.dart';
import '../firebase/firebase_providers.dart';
import '../storage/app_boxes.dart';

/// Top-level app bootstrap dependencies.
///
/// We return overrides instead of doing global singletons so everything stays
/// testable and deterministic.
Future<List<Override>> buildOverrides() async {
  await Hive.initFlutter();
  await AppBoxes.ensureOpened();

  final firebaseApp = await FirebaseInitializer.initialize(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return [
    firebaseAppProvider.overrideWithValue(firebaseApp),
  ];
}

