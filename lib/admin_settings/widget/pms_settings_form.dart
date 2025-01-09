import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rover/admin_settings/model/pms_settings.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_alert.dart';
import 'package:rover/common/widget/rover_snackbar.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_text_form_field.dart';

class PMSSettingsForm extends StatefulWidget {
  final PMSSettings? settings;

  const PMSSettingsForm({super.key, required this.settings});

  @override
  State<PMSSettingsForm> createState() => _PMSSettingsFormState();
}

class _PMSSettingsFormState extends State<PMSSettingsForm> {
  final _formKey = GlobalKey<ValidatedFormState>();
  final _pmsSettingsRepository = get<CollectionWriter<PMSSettings>>();

  String? _developerKey;
  String? _customerKey;
  String? _ipAddress;

  bool _saving = false;

  bool get _hasChange =>
      _developerKey != widget.settings?.developerKey ||
      _customerKey != widget.settings?.customerKey ||
      _ipAddress != widget.settings?.ipAddress;

  @override
  void initState() {
    super.initState();
    _developerKey = widget.settings?.developerKey;
    _customerKey = widget.settings?.customerKey;
    _ipAddress = widget.settings?.ipAddress;
  }

  /// didUpdateWidget is used here to show changes done in the pmsSettingsRepository
  /// or when the pmsSettingsRepository takes too long to load the data
  @override
  void didUpdateWidget(covariant PMSSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings?.developerKey != widget.settings?.developerKey) {
      _developerKey = widget.settings?.developerKey;
    }
    if (oldWidget.settings?.customerKey != widget.settings?.customerKey) {
      _customerKey = widget.settings?.customerKey;
    }
    if (oldWidget.settings?.ipAddress != widget.settings?.ipAddress) {
      _ipAddress = widget.settings?.ipAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValidatedForm(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildTitle(context), Spacer(flex: 2), _buildForm()],
          ),
          Divider(height: 64),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Flexible(
      child: Column(
        children: [
          Text('PMS Settings', style: appTheme?.textTheme.titleXL),
          Text('Clock PMS basic setting.', style: appTheme?.textTheme.bodyM),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget _buildForm() {
    return Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const RoverAlert(
            onClosePressed: null,
            title: null,
            variant: RoverAlertVariant.warning,
            content: "These are technical settings, and if you don't know what they are, they shouldn't be changed.",
          ),
          ValidatedTextFormField(
            validator: FormValidators.validateNotNullAndNotEmpty,
            initialValue: widget.settings?.developerKey,
            decoration: InputDecoration(label: Text('Developer Key')),
            onChanged: (value) => setState(() => _developerKey = value),
          ),
          ValidatedTextFormField(
            validator: FormValidators.validateNotNullAndNotEmpty,
            initialValue: widget.settings?.customerKey,
            decoration: InputDecoration(label: Text('Customer Key')),
            onChanged: (value) => setState(() => _customerKey = value),
          ),
          ValidatedTextFormField(
            validator: _validateIpAddress,
            initialValue: widget.settings?.ipAddress,
            decoration: InputDecoration(label: Text('IP Address'), hintText: 'https://api.opendental.com'),
            onChanged: (value) => setState(() => _ipAddress = value),
          ),
        ].intersperse(STANDARD_GAP).toList(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: PrimaryButton(
        onPressed: () async {
          setState(() => _saving = true);
          final form = _formKey.currentState;
          form?.save();
          final isValid = form?.validate() ?? false;
          if (isValid) {
            await _pmsSettingsRepository.createOrReplace(
              widget.settings?.copyWith(
                    developerKey: _developerKey,
                    customerKey: _customerKey,
                    ipAddress: _trimIpAddressEnd(_ipAddress!),
                  ) ??
                  PMSSettings(
                    id: '1',
                    developerKey: _developerKey!,
                    customerKey: _customerKey!,
                    ipAddress: _trimIpAddressEnd(_ipAddress!),
                  ),
              '1',
            );
            showRoverSnackbar(
              title: 'Settings successfully saved',
              variant: RoverSnackbarVariant.success,
              duration: Duration(seconds: 1),
              onClosePressed: (context) => OverlaySupportEntry.of(context)?.dismiss(),
            );
          }
          setState(() => _saving = false);
        },
        enabled: _hasChange,
        isLoading: _saving,
        child: Text('Save'),
      ),
    );
  }

  String _trimIpAddressEnd(String ipAddress) {
    if (ipAddress.endsWith('/api/v1/')) {
      return ipAddress.substring(0, ipAddress.length - 8);
    }
    if (ipAddress.endsWith('/api/v1')) {
      return ipAddress.substring(0, ipAddress.length - 7);
    }
    return ipAddress;
  }

  String? _validateIpAddress(String? value, {String? message}) {
    final validationResult = FormValidators.validateNotNullAndNotEmpty(value, message: message);
    if (validationResult != null) {
      return validationResult;
    }
    if (!value!.startsWith(RegExp('https?://'))) {
      return message ?? 'The IP address must be in a "http(s)://[address]" format';
    }
    return null;
  }
}
