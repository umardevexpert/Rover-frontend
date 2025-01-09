import 'package:database_kit/collection_read/contract/collection_observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:master_kit/sdk_extension/stream_extension.dart';
import 'package:rover/admin_settings/model/pms_settings.dart';
import 'package:rover/admin_settings/widget/pms_settings_form.dart';
import 'package:rover/admin_settings/widget/users_table.dart';
import 'package:rover/common/model/tab_definition.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/page_template.dart';
import 'package:rover/common/widget/page_title_with_description.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/common/widget/tabs_toggle.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/assets.dart';

const _USERS_TAB_INDEX = 0;
const _PMS_SETTING_CARD_HEIGHT = 377.0;
const _ORGANISATION_PMS_SETTINGS_ID = '1';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  late final Stream<PMSSettings?> _pmsSettingsStream;
  late final Stream<List<User>> _usersStream;
  final _pmsSettingsRepository = get<CollectionObserver<PMSSettings>>();
  final _userRepository = get<CollectionObserver<User>>();
  var _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pmsSettingsStream = _pmsSettingsRepository.observeDocument(_ORGANISATION_PMS_SETTINGS_ID).asValueBroadcastStream();
    _usersStream = _userRepository.observeDocs();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          PageTitleWithDescription(
            title: 'Admin Settings',
            description: 'Explore and collect all information about your patients',
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: PAGE_HORIZONTAL_PADDING_SIZE,
                right: PAGE_HORIZONTAL_PADDING_SIZE,
                bottom: LARGER_UI_GAP,
              ),
              child: RoverCard(
                padding: EdgeInsetsDirectional.fromSTEB(LARGE_UI_GAP, STANDARD_UI_GAP, LARGE_UI_GAP, LARGE_UI_GAP),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TabsToggle(
                          activeIndex: _activeTabIndex,
                          onIndexChanged: (index) => setState(() => _activeTabIndex = index),
                          tabs: const [TabDefinition(label: 'Users'), TabDefinition(label: 'PMS')],
                        ),
                        if (_activeTabIndex == _USERS_TAB_INDEX)
                          PrimaryButton(
                            size: PrimaryButtonSize.large,
                            onPressed: () => context.go('/admin-settings/users/createUser'),
                            prefixIcon: Assets.svgImage('icon/add'),
                            child: Text('Add new user'),
                          ),
                      ],
                    ),
                    LARGE_GAP,
                    Flexible(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: PAGE_CROSS_FADE_ANIMATION_DURATION),
                        child: _buildBody(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_activeTabIndex) {
      case 0:
        return HandlingStreamBuilder(stream: _usersStream, builder: (_, users) => UsersTable(users: users));
      case 1:
        return HandlingStreamBuilder<PMSSettings?>(
          stream: _pmsSettingsStream,
          waitingForDataWidget:
              const SizedBox(height: _PMS_SETTING_CARD_HEIGHT, child: Center(child: CircularProgressIndicator())),
          builder: (_, settings) => PMSSettingsForm(settings: settings),
        );
      default:
        throw StateError('Invalid index');
    }
  }
}
