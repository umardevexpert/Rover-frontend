import 'package:flutter/material.dart';
import 'package:rover/common/model/tab_definition.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_checkbox.dart';
import 'package:rover/common/widget/tabs_toggle.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:rover/image_capturing/model/teeth_selection_mode.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/widget/teeth_selector_with_border.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

const _TABS_TOGGLE_WIDTH = 200;

class TeethSelectorSection extends StatefulWidget {
  final double scaleRatio;

  TeethSelectorSection({super.key, required this.scaleRatio});

  @override
  State<TeethSelectorSection> createState() => _TeethSelectorSectionState();
}

class _TeethSelectorSectionState extends State<TeethSelectorSection> {
  final _dialogController = get<ImageCaptureDialogController>();
  final _missingTeethController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dialogController.showInitialTooth();
    _missingTeethController.text = _dialogController.missingTeeth.join(', ');
  }

  @override
  void dispose() {
    _missingTeethController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      children: [
        _buildTitleRow(appTheme),
        SMALL_GAP,
        HandlingStreamBuilder<Set<int>>(
          stream: _dialogController.selectedTeethStream,
          builder: (context, selectedTeeth) {
            return TeethSelectorWithBorder(
              selectedTeeth: selectedTeeth,
              onToothPressed: _dialogController.onToothPressed,
              scaleRatio: widget.scaleRatio,
            );
          },
        ),
        SMALL_GAP,
        HandlingStreamBuilder<bool>(
          stream: _dialogController.skipMissingTeethStream,
          builder: (context, skipMissingTeeth) => _buildMissingTeethInputRow(appTheme, skipMissingTeeth),
        ),
      ],
    );
  }

  Widget _buildMissingTeethInputRow(AppTheme? appTheme, bool skipMissingTeeth) {
    final colorScheme = appTheme?.colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _missingTeethController,
            decoration: InputDecoration(
              label: Text('Missing teeth (1 2; 1, 2; 1-2)'),
            ),
            onChanged: (value) {
              final toothSet = _parseMissingTeethText(value);
              if (toothSet == null) {
                return;
              }
              _dialogController.updateMissingTeeth(toothSet);

              if (_dialogController.selectedImageId == null && skipMissingTeeth) {
                _dialogController.resetTeethSelection();
                _dialogController.showInitialTooth();
              }
            },
          ),
        ),
        SMALL_GAP,
        TertiaryButton(
          onPressed: () => _handleSkipCheckboxClick(!skipMissingTeeth),
          child: Padding(
            padding: const EdgeInsets.all(SMALLER_UI_GAP),
            child: Row(
              children: [
                RoverCheckbox(
                    style: RoverCheckboxStyle.large, checked: skipMissingTeeth, onChanged: _handleSkipCheckboxClick),
                SMALLER_GAP,
                Text(
                  'skip missing teeth',
                  style: appTheme?.textTheme.bodyL.copyWith(color: colorScheme?.grey700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleSkipCheckboxClick(bool skipMissingTeeth) {
    if (_dialogController.selectedImageId == null && skipMissingTeeth) {
      _dialogController.keepFirstToothInBlock();
    }

    _dialogController.skipMissingTeeth = skipMissingTeeth;
  }

  Set<int>? _parseMissingTeethText(String text) {
    final toothSet = <int>{};
    for (final element in text.trim().split(RegExp('[, ]+'))) {
      if (element.contains('-')) {
        final parts = element.split('-');
        final toothNumberStart = int.tryParse(parts[0].trim());
        final toothNumberEnd = int.tryParse(parts[1].trim());

        if (toothNumberStart == null || toothNumberEnd == null) {
          continue;
        }

        for (var i = toothNumberStart; i <= toothNumberEnd; i++) {
          toothSet.add(i);
        }
      } else {
        final toothNumber = int.tryParse(element.trim());
        if (toothNumber == null) {
          continue;
        }

        if (toothNumber < 1 || toothNumber > 32) {
          continue;
        }

        toothSet.add(toothNumber);
      }
    }
    return toothSet;
  }

  Widget _buildTitleRow(AppTheme? appTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Select Teeth Numbers', style: appTheme?.textTheme.titleXL.copyWith(color: Colors.black)),
          ),
        ),
        SMALLER_GAP,
        SizedBox(
          width: _TABS_TOGGLE_WIDTH * widget.scaleRatio,
          child: FittedBox(
            child: HandlingStreamBuilder<TeethSelectionMode>(
              stream: _dialogController.activeTeethSelectionModeStream,
              builder: (context, mode) {
                return TabsToggle(
                  activeIndex: mode.index,
                  onIndexChanged: (index) {
                    _dialogController.activeTeethSelectionMode = TeethSelectionMode.values[index];

                    setState(() {});
                  },
                  tabs: const [TabDefinition(label: 'Manual'), TabDefinition(label: 'Auto')],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
