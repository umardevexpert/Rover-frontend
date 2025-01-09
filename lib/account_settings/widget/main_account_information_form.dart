import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:flutter/material.dart';
import 'package:rover/account_settings/widget/change_photo_popup.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/settings_row.dart';
import 'package:rover/common/widget/user_avatar.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_text_form_field.dart';
import 'package:ui_kit/util/assets.dart';

const _EDIT_BUTTON_SIZE = Size(32.0, 32.0);

class MainAccountInformationForm extends StatefulWidget {
  final User user;

  const MainAccountInformationForm({super.key, required this.user});

  @override
  State<MainAccountInformationForm> createState() => _MainAccountInformationFormState();
}

class _MainAccountInformationFormState extends State<MainAccountInformationForm> {
  final _userRepository = get<CollectionWriter<User>>();

  final _formKey = GlobalKey<ValidatedFormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;

  String? _firstName;
  String? _lastName;
  String? _phoneNumber;

  bool _saving = false;
  bool get _hasChange =>
      _firstName != widget.user.name || _lastName != widget.user.surname || _phoneNumber != widget.user.phone;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.name);
    _lastNameController = TextEditingController(text: widget.user.surname);
    _phoneNumberController = TextEditingController(text: widget.user.phone);

    _firstName = widget.user.name;
    _lastName = widget.user.surname;
    _phoneNumber = widget.user.phone;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainAccountInformationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.name != widget.user.name) {
      _firstNameController.text = widget.user.name;
      _firstName = widget.user.name;
    }
    if (oldWidget.user.surname != widget.user.surname) {
      _lastNameController.text = widget.user.surname;
      _lastName = widget.user.surname;
    }
    if (oldWidget.user.phone != widget.user.phone) {
      _phoneNumberController.text = widget.user.phone;
      _phoneNumber = widget.user.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ValidatedForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            height: 80,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _onChangeImagePressed,
                  child: UserAvatar(
                    name: widget.user.name,
                    surname: widget.user.surname,
                    profilePictureUrl: widget.user.pictureURL,
                    size: 80,
                    textStyle: appTheme?.textTheme.headingH2.copyWith(color: appTheme.colorScheme.grey500),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: PrimaryButton(
                    buttonStyle: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(6.0)),
                      fixedSize: MaterialStateProperty.all(_EDIT_BUTTON_SIZE),
                      minimumSize: MaterialStateProperty.all(_EDIT_BUTTON_SIZE),
                    ),
                    onPressed: _onChangeImagePressed,
                    child: Assets.svgImage('icon/edit', width: 20, height: 20),
                  ),
                )
              ],
            ),
          ),
          STANDARD_GAP,
          SettingsRow(
            left: ValidatedTextFormField(
              decoration: InputDecoration(labelText: 'First name'),
              controller: _firstNameController,
              onChanged: (newValue) => setState(() => _firstName = newValue),
            ),
            right: ValidatedTextFormField(
              decoration: InputDecoration(labelText: 'Last name'),
              controller: _lastNameController,
              onChanged: (newValue) => setState(() => _lastName = newValue),
            ),
          ),
          STANDARD_GAP,
          SettingsRow(
            left: ValidatedTextFormField(
              decoration: InputDecoration(labelText: 'Phone number'),
              controller: _phoneNumberController,
              onChanged: (newValue) => setState(() => _phoneNumber = newValue),
            ),
          ),
          STANDARD_GAP,
          SizedBox(
            width: 122,
            child: PrimaryButton(
              size: PrimaryButtonSize.medium,
              isLoading: _saving,
              enabled: _hasChange,
              onPressed: () async {
                setState(() => _saving = true);
                final form = _formKey.currentState;
                form?.save();
                final isValid = form?.validate() ?? false;
                if (isValid) {
                  await _userRepository.createOrReplace(
                    widget.user.copyWith(
                      name: _firstName,
                      surname: _lastName,
                      phone: _phoneNumber,
                    ),
                    widget.user.id,
                  );
                }
                setState(() => _saving = false);
              },
              child: Text('Update info'),
            ),
          ),
        ],
      ),
    );
  }

  void _onChangeImagePressed() => showDialog<void>(context: context, builder: (_) => ChangePhotoPopup());
}
