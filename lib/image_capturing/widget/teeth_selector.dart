import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/assets.dart';

final _TEETH_NUMBERS_IN_STACK_RENDER_ORDER = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] +
    [32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17];

const _UPPER_JAW_LABEL_SPACING = <double>[10, 13, 10, 5, 5, 7, 6, 8, 6, 7, 5, 5, 10, 13, 10];
const _LOWER_JAW_LABEL_SPACING = <double>[14, 23, 12, 8, 4, 3, 1, 1, 1, 3, 4, 8, 12, 23, 14];

class TeethSelector extends StatefulWidget {
  final Set<int> selectedTeeth;
  final Set<int>? missingTeeth;
  final Consumer<int> onToothPressed;

  const TeethSelector({super.key, required this.selectedTeeth, required this.onToothPressed, this.missingTeeth});

  @override
  State<TeethSelector> createState() => _TeethSelectorState();
}

class _TeethSelectorState extends State<TeethSelector> {
  final Map<int, ({PictureInfo svg, Path path})> _teethMap = {};
  final _dialogController = get<ImageCaptureDialogController>();

  @override
  void initState() {
    super.initState();
    _loadSVGs();
  }

  Future<void> _loadSVGs() async {
    final pathRegex = RegExp('d="[^"]*"');
    final mapEntries = await Future.wait(
      _TEETH_NUMBERS_IN_STACK_RENDER_ORDER.map(
        (toothNumber) async {
          final key = toothNumber.toString();
          final svgString = await rootBundle.loadString('asset/image/teeth/$key.svg');
          final regexMatch = pathRegex.firstMatch(svgString)!;
          final pathString = svgString.substring(regexMatch.start + 3, regexMatch.end - 1);
          return MapEntry(
            toothNumber,
            (svg: await vg.loadPicture(SvgStringLoader(svgString), null), path: parseSvgPath(pathString)),
          );
        },
      ),
    );
    setState(() => _teethMap.addEntries(mapEntries));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSpacedTeethLabels(
          Iterable.generate(16, (p0) => _buildToothLabel(p0 + 1)),
          _UPPER_JAW_LABEL_SPACING,
        ),
        const SizedBox(height: 1),
        HandlingStreamBuilder<Set<int>>(
          stream: _dialogController.missingTeethStream,
          builder: (context, missingTeeth) => Stack(
            alignment: Alignment.center,
            children: [
              ..._buildTeethStack(widget.missingTeeth ?? missingTeeth),
              Assets.pngImage('teeth/missing/upper_line'),
              Assets.pngImage('teeth/missing/lower_line'),
              if (_teethMap.isNotEmpty)
                for (final toothNumber in _TEETH_NUMBERS_IN_STACK_RENDER_ORDER)
                  _SelectableTooth(
                    hitTestPath: _teethMap[toothNumber]!.path,
                    svgPictureInfo: _teethMap[toothNumber]!.svg,
                    onTap: () => widget.onToothPressed(toothNumber),
                    selected: widget.selectedTeeth.contains(toothNumber),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 1),
        _buildSpacedTeethLabels(
          Iterable.generate(16, (p0) => _buildToothLabel(32 - p0)),
          _LOWER_JAW_LABEL_SPACING,
        ),
      ],
    );
  }

  List<Widget> _buildTeethStack(Set<int> missingTeeth) {
    return _TEETH_NUMBERS_IN_STACK_RENDER_ORDER
        .where((element) => !missingTeeth.contains(element))
        .map((e) => Assets.pngImage('teeth/missing/$e'))
        .toList();
  }

  Widget _buildToothLabel(int toothNumber) {
    return _ToothLabel(
      toothNumber: toothNumber,
      onTap: () => widget.onToothPressed(toothNumber),
      selected: widget.selectedTeeth.contains(toothNumber),
    );
  }

  Widget _buildSpacedTeethLabels(Iterable<Widget> toothLabels, List<double> spacing) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: toothLabels.intersperseWithIndexedGenerative((p0) => SizedBox(width: spacing[p0])).toList());
  }
}

class _ToothLabel extends StatelessWidget {
  final int toothNumber;
  final VoidCallback onTap;
  final bool selected;

  const _ToothLabel({required this.toothNumber, required this.onTap, required this.selected});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return InkWell(
      onTap: onTap,
      canRequestFocus: false,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: selected ? appTheme?.colorScheme.primaryLight : null,
          border: selected ? Border.all(color: appTheme?.colorScheme.primary ?? Colors.black) : null,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(toothNumber.toString(), style: appTheme?.textTheme.bodyS.copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _SelectableTooth extends StatelessWidget {
  final Path hitTestPath;
  final PictureInfo svgPictureInfo;
  final VoidCallback? onTap;
  final bool selected;

  const _SelectableTooth({
    required this.hitTestPath,
    required this.svgPictureInfo,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          size: Size(494, 190),
          painter: _ToothPainter(
            hitTestPath: hitTestPath,
            svgPictureInfo: svgPictureInfo,
            selected: selected,
          ),
        ),
      ),
    );
  }
}

class _ToothPainter extends CustomPainter {
  final Path hitTestPath;
  final PictureInfo svgPictureInfo;
  final bool selected;

  const _ToothPainter({required this.hitTestPath, required this.svgPictureInfo, required this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    if (selected) {
      final svgImage = svgPictureInfo.picture.toImageSync(size.width.toInt(), size.height.toInt());
      paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, size.width, size.height), image: svgImage);
    }
  }

  @override
  bool hitTest(Offset position) => hitTestPath.contains(position);

  @override
  bool shouldRepaint(covariant _ToothPainter oldDelegate) => true;
}
