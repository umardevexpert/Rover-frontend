import 'package:flutter/material.dart';
import 'package:master_kit/util/reference_wrapper.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/patient/service/patients_filtering_service.dart';
import 'package:rover/patient/widget/age_range_picker.dart';
import 'package:rover/patient/widget/appointment_date_picker.dart';
import 'package:ui_kit/util/assets.dart';

const _ICON_SIZE = 24.0;

class FilterSettingsRow extends StatefulWidget {
  FilterSettingsRow({super.key});

  @override
  State<FilterSettingsRow> createState() => _FilterSettingsRowState();
}

class _FilterSettingsRowState extends State<FilterSettingsRow> {
  final _searchTextController = TextEditingController();
  final _patientsFilteringService = get<PatientsFilteringService>();

  @override
  void initState() {
    super.initState();
    _patientsFilteringService.resetFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchTextController,
            decoration: InputDecoration(
              label: Text('Search by name, phone number or email'),
              suffixIcon: _buildSearchTextSuffixIcon(context),
            ),
            onChanged: _patientsFilteringService.filterPatientsBySearchPhrase,
          ),
        ),
        STANDARD_GAP,
        Expanded(
          child: Row(
            children: [
              Expanded(child: AgeRangePicker(onAgeRangeChanged: _patientsFilteringService.filterPatientsByAgeRange)),
              STANDARD_GAP,
              Expanded(
                child: AppointmentDatePicker(
                  onAppointmentDateChanged: (appointmentDates) {
                    _patientsFilteringService.filterPatientsByAppointmentDate(
                      from: ReferenceWrapper(appointmentDates.$1),
                      to: ReferenceWrapper(appointmentDates.$2),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTextSuffixIcon(BuildContext context) {
    final appTheme = AppTheme.of(context);

    if (_searchTextController.text.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(right: SMALL_UI_GAP),
        child: Assets.svgImage(
          'icon/search',
          width: _ICON_SIZE,
          height: _ICON_SIZE,
          color: appTheme?.colorScheme.primaryDark,
        ),
      );
    }

    return IconButton(
      padding: EdgeInsets.only(right: SMALL_UI_GAP),
      onPressed: () {
        _searchTextController.clear();
        _patientsFilteringService.filterPatientsBySearchPhrase('');
      },
      icon: Icon(Icons.close, color: appTheme?.colorScheme.primaryDark, size: _ICON_SIZE),
    );
  }
}
