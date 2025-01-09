import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rxdart/rxdart.dart';

class ToothImageStorageController {
  final _imagesController = BehaviorSubject<Map<String, List<ToothPreview>>>.seeded({});

  Stream<Map<String, List<ToothPreview>>> get imagesStream => _imagesController.stream;

  void addImage(String patientId, ToothPreview image) {
    _imagesController.add(_imagesController.value..addToOrCreateEntry(patientId, image));
  }

  void updateImage({
    required String patientId,
    required ToothPreview previewToUpdate,
    required Set<int> updatedTeethNumber,
  }) {
    final persistedImages = Map.of(_imagesController.value);
    final previewForCurrentUser = List<ToothPreview>.of(persistedImages[patientId] ?? []);
    final toothIndex = previewForCurrentUser.indexOf(previewToUpdate);

    if (toothIndex == -1) {
      return;
    }

    persistedImages[patientId] = previewForCurrentUser
      ..[toothIndex] = previewToUpdate.copyWith(teeth: updatedTeethNumber);

    _imagesController.add(persistedImages);
  }

  void removeImage(String patientId, String imageId) {
    final value = _imagesController.value;
    final images = value[patientId];
    if (images != null) {
      images.removeWhere((image) => image.id == imageId);
      _imagesController.add(value);
    }
  }
}

extension _MapWithIterableValueExtension<TKey, TValue> on Map<TKey, List<TValue>> {
  void addToOrCreateEntry(TKey key, TValue value) => (this[key] ??= []).add(value);
}
