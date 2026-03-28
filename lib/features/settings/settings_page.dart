import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/theme_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final controller = ref.read(themeModeControllerProvider.notifier);
    final locale = ref.watch(localeControllerProvider);
    final localeController = ref.read(localeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) {
              controller.setThemeMode(value.first);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          DropdownMenu<Locale?>(
            initialSelection: locale,
            label: const Text('App language'),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: null, label: 'System'),
              DropdownMenuEntry(value: Locale('en'), label: 'English'),
              DropdownMenuEntry(value: Locale('ur'), label: 'Urdu'),
            ],
            onSelected: (value) {
              localeController.setLocale(value);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Coming next',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Language switcher, CV download, Firebase-driven content, and permissions demo.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.permissions),
            icon: const Icon(Icons.security),
            label: const Text('Permissions demo'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.admin),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('Admin panel'),
          ),
        ],
      ),
    );
  }
}

