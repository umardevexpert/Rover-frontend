import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_text_form_field.dart';

class ContactInformationForm extends StatefulWidget {
  final User currentUser;
  final VoidCallback? onEditingComplete;

  const ContactInformationForm({super.key, required this.currentUser, this.onEditingComplete});

  @override
  State<ContactInformationForm> createState() => _ContactInformationFormState();
}

class _ContactInformationFormState extends State<ContactInformationForm> {
  final _formKey = GlobalKey<ValidatedFormState>();
  late final TextEditingController _emailTextController;
  late final TextEditingController _phoneTextController;

  final _userRepository = get<CollectionWriter<User>>();

  bool _hasChange = false;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController.fromValue(TextEditingValue(text: widget.currentUser.email));
    _phoneTextController = TextEditingController.fromValue(TextEditingValue(text: widget.currentUser.phone));

    _emailTextController.addListener(_verifyHasChange);
    _phoneTextController.addListener(_verifyHasChange);
  }

  @override
  void didUpdateWidget(covariant ContactInformationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _verifyHasChange();
  }

  @override
  Widget build(BuildContext context) {
    return ValidatedForm(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: ValidatedTextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(label: Text('Email')),
              validator: FormValidators.validateEmail,
            ),
          ),
          STANDARD_GAP,
          Expanded(
            child: ValidatedTextFormField(
              controller: _phoneTextController,
              decoration: InputDecoration(label: Text('Phone')),
              validator: FormValidators.validatePhoneNumber,
            ),
          ),
          LARGER_GAP,
          SizedBox(
            width: 120,
            height: STANDARD_INPUT_HEIGHT,
            child: ElevatedButton(onPressed: _hasChange ? _onSubmit : null, child: Text('Update')),
          ),
        ],
      ),
    );
  }

  void _verifyHasChange() {
    setState(() {
      _hasChange = widget.currentUser.email != _emailTextController.text ||
          widget.currentUser.phone != _phoneTextController.text;
    });
  }

  Future<void> _onSubmit() async {
    final form = _formKey.currentState;

    final isValid = form?.validate() ?? false;

    if (isValid) {
      await _userRepository.createOrReplace(
        widget.currentUser.copyWith(email: _emailTextController.text, phone: _phoneTextController.text),
        widget.currentUser.id,
      );
      widget.onEditingComplete?.call();
    }
  }
}
