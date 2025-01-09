import 'package:client_kit/auth/model/auth_result.dart';
import 'package:client_kit/auth/model/current_user.dart';
import 'package:client_kit/auth/util/auth_failure_extension.dart';
import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rover/admin_settings/widget/confirm_user_delete_dialog.dart';
import 'package:rover/admin_settings/widget/temporary_password_popup.dart';
import 'package:rover/auth/model/access_data.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_snackbar.dart';
import 'package:rover/common/widget/settings_row.dart';
import 'package:rover/common/widget/settings_section.dart';
import 'package:rover/common/widget/settings_sectioned_card.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/model/user_role.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down_form_field.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_text_form_field.dart';
import 'package:ui_kit/util/assets.dart';

const _EMAIL_VALIDATION_ID = 'email';

class CreateOrUpdateUserForm extends StatefulWidget {
  final String userId;
  final User? user;

  const CreateOrUpdateUserForm({super.key, required this.userId, this.user});

  @override
  State<CreateOrUpdateUserForm> createState() => _CreateOrUpdateUserFormState();
}

class _CreateOrUpdateUserFormState extends State<CreateOrUpdateUserForm> {
  final _authService = get<UserAuthService>();
  final _userRepository = get<CollectionWriter<User>>();
  final _formKey = GlobalKey<ValidatedFormState>();

  late bool _isUserAccountActive;
  bool _isLoading = false;

  bool get _isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    _isUserAccountActive = !(widget.user?.archived ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    String? name;
    String? surname;
    String? email;
    String? phone;
    UserRole? role;

    return ValidatedForm(
      key: _formKey,
      child: SettingsSectionedCard(
        sections: [
          SettingsSection(
            title: 'Main information',
            description: 'Lorem ipsum dolor sit amet consectetur. Et nibh convallis ultrices urna laoreet elit quam.',
            child: Column(
              children: [
                SettingsRow(
                  left: ValidatedTextFormField(
                    initialValue: widget.user?.name,
                    decoration: InputDecoration(
                      label: Text('First name'),
                    ),
                    validator: FormValidators.validateNotNullAndNotEmpty,
                    onSaved: (newName) => name = newName,
                  ),
                  right: ValidatedTextFormField(
                    initialValue: widget.user?.surname,
                    decoration: InputDecoration(
                      label: Text('Last name'),
                    ),
                    validator: FormValidators.validateNotNullAndNotEmpty,
                    onSaved: (newSurname) => surname = newSurname,
                  ),
                ),
                STANDARD_GAP,
                SettingsRow(
                  left: ValidatedTextFormField(
                    validationId: _EMAIL_VALIDATION_ID,
                    initialValue: widget.user?.email,
                    decoration: InputDecoration(
                      label: Text('Email'),
                    ),
                    validator: FormValidators.validateEmail,
                    onSaved: (newEmail) => email = newEmail,
                  ),
                  right: ValidatedTextFormField(
                    initialValue: widget.user?.phone,
                    decoration: InputDecoration(
                      label: Text('Phone number'),
                    ),
                    validator: FormValidators.validatePhoneNumber,
                    onSaved: (newPhone) => phone = newPhone,
                  ),
                ),
              ],
            ),
          ),
          SettingsSection(
            title: 'Designation',
            description: 'Lorem ipsum dolor sit amet consectetur. ',
            child: SettingsRow(
              left: DropDownFormField(
                initialValue: widget.user?.role,
                options: UserRole.values,
                displayStringForOption: (role) => role.label,
                onSaved: (newRole) => role = newRole,
                validator: FormValidators.validateNotNull,
                placeholder: 'Designation',
              ),
            ),
          ),
          if (_isEditMode)
            SettingsSection(
              title: 'Status',
              description: 'Lorem ipsum dolor sit amet consectetur. ',
              child: Row(
                children: [
                  Text('Active', style: appTheme?.textTheme.bodyL),
                  const SizedBox(width: 12),
                  CupertinoSwitch(
                    activeColor: appTheme?.colorScheme.primary,
                    value: _isUserAccountActive,
                    onChanged: (value) => setState(() => _isUserAccountActive = value),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              if (_isEditMode)
                TertiaryButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => ConfirmUserDeleteDialog(user: widget.user!),
                  ),
                  size: TertiaryButtonSize.large,
                  variant: TertiaryButtonVariant.destructive,
                  prefixIcon: Assets.svgImage('icon/delete'),
                  child: Text('Delete user'),
                ),
              const Spacer(),
              PrimaryButton(
                isLoading: _isLoading,
                size: PrimaryButtonSize.large,
                onPressed: () async {
                  setState(() => _isLoading = true);
                  final form = _formKey.currentState;
                  form?.save();
                  form?.clearExplicitValidations();
                  final isValid = form?.validate() ?? false;
                  if (!isValid) {
                    setState(() => _isLoading = false);
                    return;
                  }
                  if (_isEditMode) {
                    final updatedUser = widget.user!.copyWith(
                      name: name,
                      surname: surname,
                      role: role,
                      email: email,
                      phone: phone,
                      archived: !_isUserAccountActive,
                    );
                    await _userRepository.createOrReplace(updatedUser, updatedUser.id);
                    if (mounted) {
                      context.pop();
                    }
                  } else {
                    final password = generateRandomPassword();
                    final userId = generateRandomString();
                    final userDetails = CurrentUser(userId, email, null, false, AccessData(role: role!));

                    final authResult = await _authService.createAccount(email!, password, userDetails);

                    if (authResult.isFailure) {
                      form?.setExplicitValidation(
                        validationId: _EMAIL_VALIDATION_ID,
                        message: authResult.failure!.errorDescription,
                      );
                      form?.validateIncludingExplicit();

                      setState(() => _isLoading = false);
                      return;
                    }
                    final user = User(
                      id: userId,
                      name: name!,
                      surname: surname!,
                      role: role!,
                      email: email!,
                      phone: phone!,
                      pictureURL: null,
                      joinDate: DateTime.now(),
                      hasChangedInitialPassword: false,
                    );
                    await _userRepository.createOrReplace(user, user.id);
                    if (mounted) {
                      await showDialog<void>(
                        context: context,
                        builder: (context) => TemporaryPasswordPopup(password: password),
                      );
                    }
                    if (mounted) {
                      showRoverSnackbar(
                        variant: RoverSnackbarVariant.success,
                        onClosePressed: (context) => OverlaySupportEntry.of(context)?.dismiss(),
                        title: 'User successfully added',
                      );
                      context.pop();
                    }
                  }
                },
                child: Text(_isEditMode ? 'Save & Update' : 'Add user'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
