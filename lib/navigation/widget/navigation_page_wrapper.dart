import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/navigation/model/navigation_tab_definition.dart';
import 'package:rover/navigation/widget/logout_button.dart';
import 'package:rover/navigation/widget/navigation_tabs.dart';
import 'package:rover/navigation/widget/user_avatar_with_name.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/model/user_role.dart';
import 'package:rover/users_management/service/current_user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/assets.dart';

class NavigationPageWrapper extends StatelessWidget {
  final Widget child;

  final _userProfileService = get<UserProfileService>();

  NavigationPageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          Padding(
            padding: PAGE_HORIZONTAL_PADDING,
            child: Column(
              children: [
                SizedBox(
                  height: NAVIGATION_BAR_HEIGHT,
                  child: HandlingStreamBuilder<User>(
                    stream: _userProfileService.userProfileStream.whereNotNull(),
                    builder: (context, user) {
                      final isAdmin = user.role == UserRole.admin;
                      return Row(
                        children: [
                          Assets.svgImage('logo'),
                          const SizedBox(width: 76),
                          NavigationTabs(
                            tabs: [
                              const NavigationTabDefinition(route: '/dashboard', label: 'Patients'),
                              if (isAdmin)
                                const NavigationTabDefinition(route: '/admin-settings', label: 'Admin Settings'),
                              NavigationTabDefinition(
                                route: '/account-settings',
                                label: isAdmin ? 'Account Settings' : 'Settings',
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 44,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UserAvatarWithName(user: user),
                                VerticalDivider(
                                  width: LARGE_UI_GAP,
                                  thickness: 1,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                LogoutButton(),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Divider(height: 0, thickness: 1, color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
