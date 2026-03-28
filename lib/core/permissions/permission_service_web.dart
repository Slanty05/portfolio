import 'permission_service.dart';
import 'permission_types.dart';

/// Web permission UX varies by browser and API; this portfolio project keeps the
/// behavior explicit: show "not supported" and guide users instead of attempting
/// unreliable prompts.
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

