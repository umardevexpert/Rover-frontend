import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_kit/sdk_extension/int_extension.dart';
import 'package:rover/account_settings/widget/main_account_information_form.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/page_template.dart';
import 'package:rover/common/widget/page_title_with_description.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/common/widget/settings_row.dart';
import 'package:rover/common/widget/settings_section.dart';
import 'package:rover/common/widget/settings_sectioned_card.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/service/current_user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

class AccountSettingsPage extends StatelessWidget {
  final _userProfileService = get<UserProfileService>();

  AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      padding: EdgeInsets.zero,
      body: HandlingStreamBuilder<User>(
        stream: _userProfileService.userProfileStream.whereNotNull(),
        builder: (context, currentUser) {
          return CustomScrollView(
            slivers: [
              SliverPinnedHeader(
                child: PageTitleWithDescription(
                  title: 'Account Settings',
                  description: 'Update your profile info',
                  chipText: _getChipText(currentUser.joinDate),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: PAGE_HORIZONTAL_PADDING_SIZE,
                  right: PAGE_HORIZONTAL_PADDING_SIZE,
                  bottom: LARGER_UI_GAP,
                ),
                sliver: SliverToBoxAdapter(
                  child: SettingsSectionedCard(
                    sections: [
                      SettingsSection(
                        title: 'Main information',
                        description:
                            'Lorem ipsum dolor sit amet consectetur. Et nibh convallis ultrices urna laoreet elit quam.',
                        child: MainAccountInformationForm(user: currentUser),
                      ),
                      SettingsSection(
                        title: 'Email',
                        description: 'Lorem ipsum dolor sit amet consectetur. ',
                        child: SettingsRow(
                          left: TextField(
                            enabled: false,
                            decoration: InputDecoration(labelText: 'Email'),
                            controller: TextEditingController(text: currentUser.email),
                          ),
                        ),
                      ),
                      SettingsSection(
                        title: 'Password',
                        description:
                            'Lorem ipsum dolor sit amet consectetur. Et nibh convallis ultrices urna laoreet elit quam.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SettingsRow(
                              left: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                controller: TextEditingController(text: 'TypeSoft'),
                              ),
                            ),
                            STANDARD_GAP,
                            SecondaryButton(onPressed: () {}, child: Text('Change password')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  String _getChipText(DateTime date) => 'Joined ${date.day.asFormattedOrdinal} ${DateFormat('MMMM y').format(date)}';
}
