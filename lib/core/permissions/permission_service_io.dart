import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission_service.dart';
import 'permission_types.dart';

class PermissionServiceImpl implements PermissionService {
  @override
  Future<PermissionState> request(AppPermission permission) async {
    final p = _map(permission);
    final s = await p.request();
    return _mapStatus(s);
  }

  @override
  Future<PermissionState> status(AppPermission permission) async {
    final p = _map(permission);
    final s = await p.status;
    return _mapStatus(s);
  }

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();

  ph.Permission _map(AppPermission permission) {
    return switch (permission) {
      AppPermission.camera => ph.Permission.camera,
      AppPermission.photos => ph.Permission.photos,
      AppPermission.storage => ph.Permission.storage,
      AppPermission.locationWhenInUse => ph.Permission.locationWhenInUse,
      AppPermission.notification => ph.Permission.notification,
    };
  }

  PermissionState _mapStatus(ph.PermissionStatus status) {
    if (status.isGranted) return PermissionState.granted;
    if (status.isDenied) return PermissionState.denied;
    if (status.isPermanentlyDenied) return PermissionState.permanentlyDenied;
    if (status.isRestricted) return PermissionState.restricted;
    if (status.isLimited) return PermissionState.limited;
    return PermissionState.denied;
  }
}

