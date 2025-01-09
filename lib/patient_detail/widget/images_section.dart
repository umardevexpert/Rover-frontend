import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_kit/sdk_extension/date_time_extension.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/tooth_image_storage_controller.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:rover/patient_detail/model/tooth_image_sort_type.dart';
import 'package:rover/patient_detail/widget/images_group.dart';
import 'package:ui_kit/stream/widget/multi_stream_builder3.dart';
import 'package:ui_kit/util/assets.dart';

class ImagesSection extends StatelessWidget {
  final Patient patient;
  final _patientDetailsController = get<PatientDetailPageController>();
  final _imageStoringController = get<ToothImageStorageController>();

  ImagesSection({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return MultiStreamBuilder3(
      stream1: _patientDetailsController.imageSortType,
      stream2: _patientDetailsController.selectedTeethStream,
      stream3: _imageStoringController.imagesStream.map((event) => event[patient.id] ?? []),
      builder: (_, sortType, selectedTeeth, toothPreviews) {
        if (toothPreviews.isNullOrEmpty) {
          return _buildNoImagesScreen(appTheme);
        }
        return _buildSortedAndFilteredToothPreviews(sortType, selectedTeeth, toothPreviews);
      },
    );
  }

  Padding _buildNoImagesScreen(AppTheme? appTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LARGER_UI_GAP),
      child: SizedBox.expand(
        child: RoverCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.svgImage('no_images', width: 232, height: 152),
              const SizedBox(height: 20),
              Text(
                'There are no images yet',
                style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortedAndFilteredToothPreviews(
    ToothImageSortType sortType,
    Set<int> selectedTeeth,
    List<ToothPreview> toothPreviews,
  ) {
    final filteredPreviews = selectedTeeth.isNotEmpty
        ? toothPreviews.where((preview) => preview.teeth.containsAny(selectedTeeth)).toList()
        : toothPreviews;
    return CustomScrollView(
      slivers: sortType == ToothImageSortType.imageNewToOld || sortType == ToothImageSortType.imageOldToNew
          ? _buildGroupsByDate(filteredPreviews, sortType == ToothImageSortType.imageNewToOld).toList()
          : _buildGroupsByTeeth(filteredPreviews, sortType == ToothImageSortType.toothNumberDescending).toList(),
    );
  }

  /// Only sorting the groups order and not the images in the groups
  Iterable<Widget> _buildGroupsByDate(Iterable<ToothPreview> filteredPreviews, bool reverseOrder) {
    final groupedPreviews =
        filteredPreviews.groupBy<DateTime, ToothPreview>(keySelector: (preview) => preview.image.createdAt.startOfDay);
    return _buildGroups(groupedPreviews, reverseOrder, DateFormat(MEDIUM_DATE).format);
  }

  Iterable<Widget> _buildGroupsByTeeth(Iterable<ToothPreview> filteredPreviews, bool reverseOrder) {
    final groupedPreviews = <int, List<ToothPreview>>{};
    filteredPreviews.forEach((preview) {
      preview.teeth.forEach((toothNum) => groupedPreviews[toothNum] = (groupedPreviews[toothNum] ?? [])..add(preview));
    });
    return _buildGroups(groupedPreviews, reverseOrder, (i) => i.toString());
  }

  Iterable<Widget> _buildGroups<TKey>(
    Map<TKey, List<ToothPreview>> groupedPreviews,
    bool reverseOrder,
    Projector<TKey, String> groupNameBuilder,
  ) sync* {
    final orderedKeys = groupedPreviews.keys.toList()..sort();
    for (final key in reverseOrder ? orderedKeys.reversed : orderedKeys) {
      final previews = groupedPreviews[key];
      if (previews.isNotNullNotEmpty) {
        yield ImagesGroup(groupTitle: groupNameBuilder(key), previews: previews!, patient: patient);
        yield SliverToBoxAdapter(child: STANDARD_GAP);
      }
    }
    // Last gap should be LARGER_GAP => STANDARD_GAP + SMALLER_GAP
    yield SliverToBoxAdapter(child: SMALLER_GAP);
  }
}
