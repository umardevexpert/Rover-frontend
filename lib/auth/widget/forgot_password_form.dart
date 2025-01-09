import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/auth/widget/email_field.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_alert.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/assets.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<ValidatedFormState>();
  bool _isLoading = false;
  bool _showInfoMessage = false;
  DateTime? _sentTimestamp;

  @override
  Widget build(BuildContext context) {
    String? email;

    return ValidatedForm(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailField(onSaved: (value) => email = value),
          if (_showInfoMessage)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: RoverAlert(
                onClosePressed: () => setState(() => _showInfoMessage = false),
                variant: RoverAlertVariant.info,
                title: 'Reset link was sent!',
                content: 'Instructions for changing the password have been sent to your email address.',
              ),
            ),
          LARGER_GAP,
          HandlingStreamBuilder(
              stream: Stream<void>.periodic(const Duration(seconds: 1)),
              builder: (context, _) {
                final remainingTime =
                    _sentTimestamp == null ? 0 : 60 - DateTime.now().difference(_sentTimestamp!).inSeconds;

                return PrimaryButton(
                  size: PrimaryButtonSize.large,
                  isLoading: _isLoading,
                  enabled: remainingTime <= 0,
                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                        _showInfoMessage = false;
                      });
                      // TODO(jakub) send email instead of fake delay
                      await Future<void>.delayed(Duration(milliseconds: 500));
                      setState(() {
                        _isLoading = false;
                        _showInfoMessage = true;
                        _sentTimestamp = DateTime.now();
                      });
                    }
                  },
                  child: Text(_getButtonText(remainingTime)),
                );
              }),
          SMALL_GAP,
          SecondaryButton(
            size: SecondaryButtonSize.large,
            onPressed: () => context.pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.svgImage('icon/arrow_left', width: 24, height: 24),
                SMALL_GAP,
                Text('Back'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(int remainingTime) {
    if (_sentTimestamp == null) {
      return 'Reset password';
    }
    if (remainingTime > 0) {
      return 'Resend link ($remainingTime sec)';
    }
    return 'Resend link';
  }
}
