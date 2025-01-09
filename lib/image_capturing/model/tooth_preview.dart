import 'package:rover/image_capturing/model/rover_tooth_image.dart';

class ToothPreview {
  final String id;
  final RoverToothImage image;
  final Set<int> teeth;
  final Set<int> missingTeeth;

  ToothPreview(this.image, {Set<int>? teeth, Set<int>? missingTeeth})
      : id = image.id,
        teeth = teeth ?? {},
        missingTeeth = missingTeeth ?? {};

  ToothPreview copyWith({
    RoverToothImage? image,
    Set<int>? teeth,
    Set<int>? missingTeeth,
  }) {
    return ToothPreview(
      image ?? this.image,
      teeth: teeth ?? this.teeth,
      missingTeeth: missingTeeth ?? this.missingTeeth,
    );
  }
}
