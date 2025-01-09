import 'package:client_kit/auth/model/auth_result.dart';
import 'package:client_kit/auth/util/auth_failure_extension.dart';
import 'package:database_kit/collection_read/contract/collection_observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/auth/widget/email_field.dart';
import 'package:rover/auth/widget/password_field.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_checkbox.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';

const _PASSWORD_FIELD_VALIDATION_ID = 'password-field';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<ValidatedFormState>();
  final _authService = get<UserAuthService>();
  final _userRepository = get<CollectionObserver<User>>();

  bool _rememberLogin = false;
  bool _isLoading = false;

  // TODO(matej): Moved up from build method, check if we want to clear email & password
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return ValidatedForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          EmailField(textInputAction: TextInputAction.next, onSaved: (value) => _email = value),
          STANDARD_GAP,
          PasswordField(
            label: Text('Password'),
            validationId: _PASSWORD_FIELD_VALIDATION_ID,
            validator: FormValidators.validateNotNullAndNotEmpty,
            onSaved: (value) => _password = value,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              RoverCheckbox(
                checked: _rememberLogin,
                onChanged: (value) => setState(() => _rememberLogin = value),
              ),
              SMALLER_GAP,
              Text('Remember me', style: AppTheme.of(context)?.textTheme.bodyM),
              Spacer(),
              TertiaryButton(
                onPressed: () => context.go('/login/forgot-password'),
                child: Text('Forgot password?'),
              )
            ],
          ),
          const SizedBox(height: 42),
          PrimaryButton(
            size: PrimaryButtonSize.large,
            isLoading: _isLoading,
            onPressed: onSubmit,
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit() async {
    final form = _formKey.currentState;

    form?.clearExplicitValidations();
    form?.save();
    final isValid = form?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.signInWithUserNameAndPassword(_email!, _password!);

    if (result.isFailure) {
      form?.setExplicitValidation(
        validationId: _PASSWORD_FIELD_VALIDATION_ID,
        message: result.failure!.errorDescription,
      );
      form?.validateIncludingExplicit();
    } else {
      final userId = (await _authService.signedInUserStream.first)?.id;
      final userDoc = await _userRepository.observeDocument(userId!).first;

      if (userDoc != null && !userDoc.hasChangedInitialPassword && mounted) {
        context.go('/change-initial-password', extra: _password);
      }
    }
    setState(() => _isLoading = false);
  }
}
