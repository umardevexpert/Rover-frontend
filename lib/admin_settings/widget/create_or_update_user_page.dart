import 'package:database_kit/collection_read/contract/collection_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rover/admin_settings/widget/create_or_update_user_form.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/page_template.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

class CreateOrUpdateUserPage extends StatelessWidget {
  final String userId;
  final _userRepository = get<CollectionObserver<User>>();

  CreateOrUpdateUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      padding: const EdgeInsets.only(
        left: PAGE_HORIZONTAL_PADDING_SIZE,
        right: PAGE_HORIZONTAL_PADDING_SIZE,
        bottom: LARGER_UI_GAP,
      ),
      hasBackButton: true,
      backButtonText: 'Back to Admin settings',
      // TODO(pavel / matej): We needlessly observe non-existing id when creating a new user
      body: HandlingStreamBuilder(
        ignoreNullInitialData: true,
        stream: _userRepository.observeDocument(userId),
        builder: (context, user) => CreateOrUpdateUserForm(userId: userId, user: user),
      ),
    );
  }
}
