import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/date_time_picker.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/input/popup/widget/popup_decorator.dart';
import 'package:ui_kit/util/assets.dart';

const _POPUP_CONTENT_HEIGHT = 230.0;
final _dateFormat = DateFormat(MEDIUM_DATE).format;

class AppointmentDatePicker extends StatefulWidget {
  final ValueChanged<(DateTime?, DateTime?)> onAppointmentDateChanged;

  AppointmentDatePicker({super.key, required this.onAppointmentDateChanged});

  @override
  State<AppointmentDatePicker> createState() => _AppointmentDatePickerState();
}

class _AppointmentDatePickerState extends State<AppointmentDatePicker> {
  final _popupController = PopupController();
  final _textEditingController = TextEditingController();

  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return PopupDecorator(
      controller: _popupController,
      popupContentBuilder: (context, size) => _buildPopupContent(context),
      popupContentHeight: _POPUP_CONTENT_HEIGHT,
      popupPadding: EdgeInsets.only(top: 4),
      child: TextField(
        controller: _textEditingController,
        readOnly: true,
        onTap: _popupController.showPopup,
        decoration: InputDecoration(
          labelText: 'Appointment date',
          prefixText: _buildPrefixText(),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: SMALL_UI_GAP),
            child: Assets.svgImage(
              'icon/appointment_calendar',
              color: appTheme?.colorScheme.primaryDark,
            ),
          ),
        ),
      ),
    );
  }

  String? _buildPrefixText() {
    if ((_fromDate == null && _toDate == null) || (_fromDate != null && _toDate != null)) {
      return null;
    }

    return _fromDate != null ? 'After: ' : 'Before: ';
  }

  Widget _buildPopupContent(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: STANDARD_BORDER_RADIUS,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(STANDARD_UI_GAP),
        child: Column(
          children: [
            DateTimePicker.from(
              value: _fromDate,
              onChanged: (newFromDate) {
                setState(() => _fromDate = newFromDate);
                widget.onAppointmentDateChanged((_fromDate, _toDate));
                _setAppointmentLabelDate();
              },
            ),
            STANDARD_GAP,
            DateTimePicker.to(
              value: _toDate,
              onChanged: (newToDate) {
                setState(() => _toDate = newToDate);
                widget.onAppointmentDateChanged((_fromDate, _toDate));
                _setAppointmentLabelDate();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setAppointmentLabelDate() {
    if (_fromDate == null && _toDate == null) {
      _textEditingController.text = '';
      return;
    }

    if (_fromDate == null) {
      _textEditingController.text = _dateFormat(_toDate!);
      return;
    }

    if (_toDate == null) {
      _textEditingController.text = _dateFormat(_fromDate!);
      return;
    }

    _textEditingController.text = '${_dateFormat(_fromDate!)} - ${_dateFormat(_toDate!)}';
  }
}
