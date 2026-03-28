import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions/permission_providers.dart';
import '../../core/permissions/permission_types.dart';

class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(permissionServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'This screen demonstrates robust permission handling. '
            'On web, permissions are treated as not supported and you should guide users via browser UI.',
          ),
          const SizedBox(height: 16),
          for (final p in AppPermission.values) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _label(p),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final s = await service.status(p);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Status: ${_stateLabel(s)}')),
                          );
                        }
                      },
                      child: const Text('Status'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final s = await service.request(p);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Request result: ${_stateLabel(s)}'),
                            ),
                          );
                        }
                      },
                      child: const Text('Request'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            onPressed: () async {
              final ok = await service.openAppSettings();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? 'Opened settings' : 'Not available')),
                );
              }
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open app settings'),
          ),
        ],
      ),
    );
  }

  String _label(AppPermission p) {
    return switch (p) {
      AppPermission.camera => 'Camera',
      AppPermission.photos => 'Photos',
      AppPermission.storage => 'Storage',
      AppPermission.locationWhenInUse => 'Location (when in use)',
      AppPermission.notification => 'Notifications',
    };
  }

  String _stateLabel(PermissionState s) {
    return switch (s) {
      PermissionState.granted => 'granted',
      PermissionState.denied => 'denied',
      PermissionState.permanentlyDenied => 'permanently denied',
      PermissionState.restricted => 'restricted',
      PermissionState.limited => 'limited',
      PermissionState.notSupported => 'not supported',
    };
  }
}

