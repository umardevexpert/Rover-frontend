import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:rover/auth/widget/password_field.dart';
import 'package:rover/auth/widget/password_validation_popup.dart';

class NewPasswordField extends StatefulWidget {
  final String? validationId;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const NewPasswordField({
    super.key,
    this.validationId,
    this.validator,
    this.onSaved,
  });

  @override
  State<NewPasswordField> createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends State<NewPasswordField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _showPopup = false;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(() => setState(() => _password = _controller.text));
    _focusNode.addListener(() => setState(() => _showPopup = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _showPopup,
      anchor: const Aligned(
        follower: Alignment.centerLeft,
        target: Alignment.centerRight,
        offset: Offset(6, 0),
      ),
      portalFollower: PasswordValidationPopup(password: _password),
      child: PasswordField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.next,
        label: Text('New password'),
        validationId: widget.validationId,
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
