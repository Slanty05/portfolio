import 'permission_service.dart';
import 'permission_types.dart';

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> openAppSettings() async => false;

  @override
  Future<PermissionState> request(AppPermission permission) async {
    return PermissionState.notSupported;
  }

  @override
  Future<PermissionState> status(AppPermission permission) async {
    return PermissionState.notSupported;
  }
}

