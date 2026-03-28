import 'permission_types.dart';

import 'permission_service_stub.dart'
    if (dart.library.io) 'permission_service_io.dart'
    if (dart.library.html) 'permission_service_web.dart';

abstract interface class PermissionService {
  Future<PermissionState> request(AppPermission permission);
  Future<PermissionState> status(AppPermission permission);
  Future<bool> openAppSettings();
}

PermissionService createPermissionService() => PermissionServiceImpl();

