import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/experience/experience_page.dart';
import '../../features/home/home_page.dart';
import '../../features/projects/projects_page.dart';
import '../../features/permissions/permissions_page.dart';
import '../../features/admin/admin_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/shell/app_shell_page.dart';
import '../../features/splash/splash_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.projects,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProjectsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.experience,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ExperiencePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsPage()),
                routes: [
                  GoRoute(
                    path: 'permissions',
                    builder: (context, state) => const PermissionsPage(),
                  ),
                  GoRoute(
                    path: 'admin',
                    builder: (context, state) => const AdminPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

