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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsCard(
            children: [
              _SettingsActionTile(
                title: 'Display',
                value: _themeModeLabel(themeMode),
                onTap: () async {
                  final selected = await _showSelectionSheet<ThemeMode>(
                    context: context,
                    title: 'Display',
                    value: themeMode,
                    options: const [
                      _Option(value: ThemeMode.system, label: 'Automatic'),
                      _Option(value: ThemeMode.light, label: 'Light'),
                      _Option(value: ThemeMode.dark, label: 'Dark'),
                    ],
                  );
                  if (selected != null) {
                    await controller.setThemeMode(selected);
                  }
                },
              ),
              _SettingsActionTile(
                title: 'Language',
                value: _localeLabel(locale),
                onTap: () async {
                  final selected = await _showSelectionSheet<String>(
                    context: context,
                    title: 'Language',
                    value: _localeCode(locale),
                    options: const [
                      _Option(value: 'system', label: 'System'),
                      _Option(value: 'en', label: 'English'),
                      _Option(value: 'ur', label: 'Urdu'),
                    ],
                  );
                  if (selected != null) {
                    await localeController.setLocale(
                      switch (selected) {
                        'system' => null,
                        'ur' => const Locale('ur'),
                        _ => const Locale('en'),
                      },
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Coming next',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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

String _themeModeLabel(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => 'Automatic',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };
}

String _localeLabel(Locale? locale) {
  if (locale == null) return 'System';
  if (locale.languageCode == 'ur') return 'Urdu';
  return 'English';
}

String _localeCode(Locale? locale) {
  if (locale == null) return 'system';
  return locale.languageCode == 'ur' ? 'ur' : 'en';
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more_rounded),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _Option<T> {
  const _Option({required this.value, required this.label});

  final T value;
  final String label;
}

Future<T?> _showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required T value,
  required List<_Option<T>> options,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  for (final option in options)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: Icon(
                        option.value == value
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(option.label),
                      onTap: () => Navigator.of(context).pop(option.value),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

