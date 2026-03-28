import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer(
    overrides: await buildOverrides(),
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PortfolioApp(),
    ),
  );
}

