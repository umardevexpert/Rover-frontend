import 'package:database_kit/collection_read/contract/collection_getter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/account_settings/widget/account_settings_page.dart';
import 'package:rover/admin_settings/widget/admin_settings_page.dart';
import 'package:rover/admin_settings/widget/create_or_update_user_page.dart';
import 'package:rover/auth/widget/auth_page_template.dart';
import 'package:rover/auth/widget/change_initial_password_page.dart';
import 'package:rover/auth/widget/forgot_password_page.dart';
import 'package:rover/auth/widget/login_blocked_page.dart';
import 'package:rover/auth/widget/login_page.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/navigation/utils/go_router_refresh_stream.dart';
import 'package:rover/navigation/widget/navigation_page_wrapper.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/widget/patients_page.dart';
import 'package:rover/patient_detail/widget/patient_detail_page.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/model/user_role.dart';

GoRouter buildRouter(UserAuthService authService, CollectionGetter<User> userRepository) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final userId = (await authService.signedInUserStream.first)?.id;
      if (userId == null) {
        return '/login';
      }
      if (state.matchedLocation == '/login') {
        final x = await userRepository.getDocument(userId);
        if (x == null) {
          return '/login';
        }
        if (x.hasChangedInitialPassword) {
          return '/dashboard';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authService.authStream),
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/dashboard'),
      ShellRoute(
        builder: (context, state, child) => AuthPageTemplate(body: child),
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginPage(),
            routes: [GoRoute(path: 'forgot-password', builder: (context, state) => ForgotPasswordPage())],
          ),
          GoRoute(
            path: '/change-initial-password',
            builder: (context, state) => ChangeInitialPasswordPage(oldPassword: state.extra as String),
          ),
          GoRoute(
            path: '/login-blocked',
            builder: (context, state) => LoginBlockedPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => NavigationPageWrapper(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: PatientsPage(),
              transitionsBuilder: fadeTransitionBuilder,
            ),
            routes: [
              GoRoute(
                path: 'patient-detail',
                builder: (context, state) => PatientDetailPage(patient: state.extra as Patient),
              ),
            ],
          ),
          GoRoute(
            path: '/account-settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: AccountSettingsPage(),
              transitionsBuilder: fadeTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/admin-settings',
            redirect: (context, state) async {
              final currentUser = await authService.signedInUserStream.first;
              if (currentUser?.accessInfo?.role != UserRole.admin) {
                return '/dashboard';
              }
              return null;
            },
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: AdminSettingsPage(),
              transitionsBuilder: fadeTransitionBuilder,
            ),
            routes: [
              GoRoute(
                path: 'users/:userId',
                builder: (context, state) => CreateOrUpdateUserPage(userId: state.pathParameters['userId']!),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget fadeTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
    child: child,
  );
}
