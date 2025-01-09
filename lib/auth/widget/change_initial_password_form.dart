import 'package:client_kit/auth/model/auth_result.dart';
import 'package:client_kit/auth/util/auth_failure_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rover/auth/widget/new_password_field.dart';
import 'package:rover/auth/widget/password_field.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_snackbar.dart';
import 'package:rover/users_management/service/current_user_service.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:ui_kit/layout/widget/content_width_limiter.dart';

const _MAX_WIDTH = 400.0;
const _CONFIRM_PASSWORD_VALIDATION_ID = 'confirm-password';

class ChangeInitialPasswordForm extends StatefulWidget {
  final String oldPassword;

  const ChangeInitialPasswordForm({super.key, required this.oldPassword});

  @override
  State<ChangeInitialPasswordForm> createState() => _ChangeInitialPasswordFormState();
}

class _ChangeInitialPasswordFormState extends State<ChangeInitialPasswordForm> {
  final _formKey = GlobalKey<ValidatedFormState>();
  final _authService = get<UserAuthService>();
  final _userProfileService = get<UserProfileService>();

  bool _isLoading = false;

  // TODO(matej): Moved up from build method, check if we want to clear email & password
  String? _password;
  String? _repeatedPassword;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ContentWidthLimiter(
        maxWidth: _MAX_WIDTH,
        child: ValidatedForm(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NewPasswordField(
                validator: FormValidators.validatePasswordStrength,
                onSaved: (value) => _password = value,
              ),
              STANDARD_GAP,
              PasswordField(
                label: Text('Confirm new password'),
                validationId: _CONFIRM_PASSWORD_VALIDATION_ID,
                validator: FormValidators.validateNotNullAndNotEmpty,
                onSaved: (value) => _repeatedPassword = value,
                onFieldSubmitted: (_) => onSubmit(),
              ),
              const SizedBox(height: 42),
              PrimaryButton(
                size: PrimaryButtonSize.large,
                isLoading: _isLoading,
                onPressed: onSubmit,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    final form = _formKey.currentState;
    form?.save();

    final passwordsMatch = _password == _repeatedPassword;

    form?.setExplicitValidation(
      validationId: _CONFIRM_PASSWORD_VALIDATION_ID,
      message: passwordsMatch ? null : 'Passwords do not match.',
    );

    final isValid = form?.validateIncludingExplicit() ?? false;
    if (isValid) {
      setState(() => _isLoading = true);
      final authResult = await _authService.changePassword(widget.oldPassword, _password!);

      if (authResult.isFailure) {
        showRoverSnackbar(
          variant: RoverSnackbarVariant.error,
          onClosePressed: (context) => OverlaySupportEntry.of(context)?.dismiss(),
          title: authResult.failure!.errorDescription,
        );
      } else {
        await _userProfileService.setCurrentUserHasChangedPassword(hasChanged: true);
        if (mounted) {
          context.go('/dashboard');
        }
      }
      setState(() => _isLoading = false);
    }
  }
}
