import 'package:flutter/material.dart';
import 'package:rover/auth/widget/password_field.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';

const _CONFIRM_PASSWORD_VALIDATION_ID = 'confirm-password';

class ChangePasswordPopup extends StatefulWidget {
  const ChangePasswordPopup({super.key});

  @override
  State<ChangePasswordPopup> createState() => _ChangePasswordPopupState();
}

class _ChangePasswordPopupState extends State<ChangePasswordPopup> {
  final _formKey = GlobalKey<ValidatedFormState>();
  final _authService = get<UserAuthService>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String? oldPassword;
    String? newPassword;
    String? newPasswordRepeated;

    return ValidatedForm(
      key: _formKey,
      child: AlertDialog(
        title: Text('Change Password'),
        content: SizedBox(
          width: 400,
          height: 300,
          child: IndexedStack(
            index: _isLoading ? 1 : 0,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PasswordField(
                    label: Text('Old Password'),
                    validator: FormValidators.validateNotNullAndNotEmpty,
                    onSaved: (value) => oldPassword = value,
                  ),
                  STANDARD_GAP,
                  PasswordField(
                    label: Text('New Password'),
                    validator: FormValidators.validatePasswordStrength,
                    onSaved: (value) => newPassword = value,
                  ),
                  STANDARD_GAP,
                  PasswordField(
                    label: Text('Repeat New Password'),
                    onSaved: (value) => newPasswordRepeated = value,
                    validationId: _CONFIRM_PASSWORD_VALIDATION_ID,
                    validator: FormValidators.validateNotNullAndNotEmpty,
                  ),
                ],
              ),
              Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: _isLoading ? null : () => Navigator.of(context).pop(), child: Text('Cancel')),
          TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    final form = _formKey.currentState;

                    form?.save();

                    final passwordsMatch = newPassword == newPasswordRepeated;

                    form?.setExplicitValidation(
                      validationId: _CONFIRM_PASSWORD_VALIDATION_ID,
                      message: passwordsMatch ? null : 'Passwords do not match.',
                    );

                    final isValid = form?.validateIncludingExplicit() ?? false;

                    if (isValid) {
                      await _authService.changePassword(oldPassword!, newPassword!);

                      // TODO(jirka): Add ui error message when change password returns error
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                    setState(() => _isLoading = false);
                  },
            child: Text('Change'),
          ),
        ],
      ),
    );
  }
}
