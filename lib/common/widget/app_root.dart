import 'package:database_kit/collection_read/contract/collection_getter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/light_theme.dart';
import 'package:rover/navigation/routes.dart';
import 'package:rover/users_management/model/user.dart';

const TOP_PORTAL_LAYER_ID = 'top-portal-layer';

class AppRoot extends StatelessWidget {
  final _authService = get<UserAuthService>();
  final _userRepository = get<CollectionGetter<User>>();

  AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: Portal(
        labels: const [PortalLabel<String>(TOP_PORTAL_LAYER_ID)],
        child: Portal(
          child: MaterialApp.router(
            title: 'Rover',
            theme: lightTheme,
            routerConfig: buildRouter(_authService, _userRepository),
          ),
        ),
      ),
    );
  }
}
