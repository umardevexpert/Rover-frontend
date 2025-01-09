import 'package:collection/collection.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:master_kit/sdk_extension/iterable/set_extension.dart';
import 'package:rover/common/model/snackbar_model.dart';
import 'package:rover/image_capturing/model/jaw.dart';
import 'package:rover/image_capturing/model/teeth_selection_mode.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/tooth_image_storage_controller.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rxdart/rxdart.dart';

const _INITIAL_BLOCK_SIZE = 1;

const _LEFT_MOST_UPPER_JAW_TOOTH = 1;
const _RIGHT_MOST_UPPER_JAW_TOOTH = 16;
const _RIGHT_MOST_LOWER_JAW_TOOTH = 17;
const _LEFT_MOST_LOWER_JAW_TOOTH = 32;
const _TOTAL_TEETH_COUNT = 32;

class ImageCaptureDialogController {
  final ToothImageStorageController _imageStorageController;
  final _showHintStreamController = BehaviorSubject.seeded(true);
  final _toothPreviewsStreamController = BehaviorSubject.seeded(<String, ToothPreview>{});
  final BehaviorSubject<String?> _selectedToothPreviewIDStreamController = BehaviorSubject<String?>.seeded(null);
  final _selectedTeethStreamController = BehaviorSubject.seeded(<int>{});
  final _skipMissingTeethStreamController = BehaviorSubject.seeded(true);
  final _missingTeethStreamController = BehaviorSubject.seeded(<int>{});
  final _hasErrorStreamController = BehaviorSubject.seeded(false);
  final _activeTeethSelectionModeStreamController = BehaviorSubject.seeded(TeethSelectionMode.manual);

  Patient? patient;
  int _blockSize = _INITIAL_BLOCK_SIZE;

  ImageCaptureDialogController(this._imageStorageController);

  Stream<bool> get showHintStream => _showHintStreamController.stream;

  Stream<Map<String, ToothPreview>> get toothPreviewsStream => _toothPreviewsStreamController.stream;

  Stream<String?> get selectedToothPreviewIDStream => _selectedToothPreviewIDStreamController.stream;

  Stream<Set<int>> get selectedTeethStream => _selectedTeethStreamController.stream;

  Stream<Set<int>> get missingTeethStream => _missingTeethStreamController.stream;

  Stream<bool> get skipMissingTeethStream => _skipMissingTeethStreamController.stream;

  Stream<bool> get isErrorStream => _hasErrorStreamController.stream;

  Stream<TeethSelectionMode> get activeTeethSelectionModeStream => _activeTeethSelectionModeStreamController.stream;

  Map<String, ToothPreview> get _toothPreviews => _toothPreviewsStreamController.stream.value;

  String? get selectedImageId => _selectedToothPreviewIDStreamController.stream.value;

  Set<int> get selectedTeeth => _selectedTeethStreamController.stream.value;

  Set<int> get missingTeeth => _missingTeethStreamController.stream.value;

  TeethSelectionMode get activeTeethSelectionMode => _activeTeethSelectionModeStreamController.stream.value;

  set activeTeethSelectionMode(TeethSelectionMode value) {
    if (activeTeethSelectionMode != value) {
      _activeTeethSelectionModeStreamController.add(value);
    }
  }

  bool get skipMissingTeeth => _skipMissingTeethStreamController.stream.value;

  set skipMissingTeeth(bool value) {
    if (skipMissingTeeth != value) {
      _skipMissingTeethStreamController.add(value);
    }
  }

  Set<int> _initialMissingTeeth = {};

  set initialMissingTeeth(Set<int> missingTeeth) {
    _initialMissingTeeth = missingTeeth;
    _missingTeethStreamController.add(missingTeeth);
  }

  void closeHint() => _showHintStreamController.add(false);

  void setOrAddToothPreview(String previewId, ToothPreview preview) =>
      _toothPreviewsStreamController.add({..._toothPreviews, previewId: preview});

  void removeToothPreview(String previewId) {
    if (previewId == _selectedToothPreviewIDStreamController.value) {
      deselectCurrentImage();
    }

    if (skipMissingTeeth) {
      keepFirstToothInBlock();
    }
    _toothPreviewsStreamController.add({..._toothPreviews}..remove(previewId));
  }

  ToothPreview? getToothPreview(String id) => _toothPreviews[id];

  void keepFirstToothInBlock() {
    if (selectedTeeth.isEmpty) {
      return;
    }
    _blockSize = 1;
    _selectedTeethStreamController.add(_findTeethBlock(
      startingTooth: selectedTeeth.min,
      blockSize: 1,
      skipMissingTeeth: true,
    ));
  }

  Set<int> showInitialTooth() {
    final initialTeeth = _findTeethBlock(startingTooth: 1, blockSize: 1, skipMissingWithImage: true);
    _selectedTeethStreamController.add(initialTeeth);
    return initialTeeth;
  }

  void toggleImageSelection(String id) {
    if (id == _selectedToothPreviewIDStreamController.value) {
      deselectCurrentImage();
      if (skipMissingTeeth) {
        keepFirstToothInBlock();
      }
      return;
    }
    _selectImage(id);
  }

  void deselectCurrentImage() {
    if (_selectedToothPreviewIDStreamController.value == null) {
      return;
    }

    _selectedToothPreviewIDStreamController.add(null);
  }

  ToothPreview? getSelectedToothPreview() => _toothPreviews[selectedImageId];

  void onToothPressed(int tooth, {bool updateToothPreview = true}) {
    if (selectedImageId == null && missingTeeth.contains(tooth) && skipMissingTeeth) {
      return;
    }

    final candidateSelectedTeeth = Set<int>.from(selectedTeeth);
    candidateSelectedTeeth.addOrRemoveIfExists(tooth);

    if (candidateSelectedTeeth.isEmpty) {
      return;
    }

    if (candidateSelectedTeeth.length == 1) {
      changeToothSelection(tooth, updateToothPreview: updateToothPreview);
      return;
    }

    if (!candidateSelectedTeeth.isSequencePermutation() || !_isInTheSameRow(candidateSelectedTeeth)) {
      resetTeethSelection();
    }

    if (skipMissingTeeth && selectedImageId == null) {
      resetTeethSelection();
    }

    changeToothSelection(tooth, updateToothPreview: updateToothPreview);
  }

  void updateMissingTeeth(Set<int> toothSet) => _missingTeethStreamController.add(toothSet);

  void updateSelectedTeeth(Set<int> toothSet) => _selectedTeethStreamController.add(toothSet);

  void selectPreviousTeethBlock() {
    if (selectedTeeth.isEmpty) {
      return;
    }

    final newTeethBlock = _findTeethBlock(startingTooth: selectedTeeth.min - 1, isForward: false);
    _selectedTeethStreamController.add(newTeethBlock);

    if (selectedImageId != null) {
      updateTeethOfToothPreview(getSelectedToothPreview(), newTeethBlock);
    }
  }

  void selectNextTeethBlock() {
    if (selectedTeeth.isEmpty) {
      return;
    }

    final newTeethBlock = _findTeethBlock(startingTooth: selectedTeeth.max + 1);
    _selectedTeethStreamController.add(newTeethBlock);

    if (selectedImageId != null) {
      updateTeethOfToothPreview(getSelectedToothPreview(), newTeethBlock);
    }
  }

  void resetTeethSelection() => _selectedTeethStreamController.add(<int>{});

  void resetStreams() {
    _toothPreviewsStreamController.add(<String, ToothPreview>{});
    _selectedToothPreviewIDStreamController.add(null);
    showInitialTooth();
    _blockSize = _INITIAL_BLOCK_SIZE;
    _missingTeethStreamController.add(_initialMissingTeeth);
    _hasErrorStreamController.add(false);
    _skipMissingTeethStreamController.add(true);
  }

  Future<SnackBarModel?> saveToothPreviews() async {
    _toothPreviews.forEach((_, value) async => _imageStorageController.addImage(patient!.id, value));
    return null;
  }

  Future<SnackBarModel?> updateToothPreview(ToothPreview preview) async {
    final updatedToothPreview = _toothPreviews[preview.id];
    if (updatedToothPreview == null) {
      return null;
    }

    _imageStorageController.updateImage(
      patientId: patient!.id,
      previewToUpdate: preview,
      updatedTeethNumber: updatedToothPreview.teeth,
    );

    return null;
  }

  void changeToothSelection(int tooth, {bool updateToothPreview = true}) {
    final candidateSelectedTeeth = Set<int>.from(selectedTeeth);
    candidateSelectedTeeth.addOrRemoveIfExists(tooth);
    _selectedTeethStreamController.add(candidateSelectedTeeth);

    _blockSize = candidateSelectedTeeth.length;

    if (selectedImageId != null && updateToothPreview) {
      updateTeethOfToothPreview(getSelectedToothPreview(), candidateSelectedTeeth);
    }
  }

  void updateTeethOfToothPreview(ToothPreview? toothPreview, Set<int> teethSet) {
    setOrAddToothPreview(selectedImageId!, toothPreview!.copyWith(teeth: Set.from(teethSet)));
  }

  void _selectImage(String id) {
    final previewTeeth = getToothPreview(id)?.teeth;
    _selectedTeethStreamController.add(previewTeeth ?? {});

    if (previewTeeth != null) {
      _blockSize = previewTeeth.length;
    }

    _selectedToothPreviewIDStreamController.add(id);
  }

  Set<int> _findTeethBlock({
    required int startingTooth,
    bool isForward = true,
    int? blockSize,
    bool? skipMissingTeeth,
    bool skipMissingWithImage = false,
  }) {
    final teethCycle = List.generate(
      _TOTAL_TEETH_COUNT,
      (index) => _mapToothCycle(startingTooth + (isForward ? index : -index)),
    );

    final newBlock = teethCycle
        .where((element) =>
            !(skipMissingWithImage || selectedImageId == null) ||
            !(skipMissingTeeth ?? this.skipMissingTeeth) ||
            !missingTeeth.contains(element))
        .take(blockSize ?? _blockSize)
        .toSet();

    if (_isInTheSameRow(newBlock)) {
      return newBlock;
    }

    return _filterSelectionToJaw(newBlock, _getJawOfToothBlock(selectedTeeth));
  }

  int _mapToothCycle(int input) =>
      (input % _TOTAL_TEETH_COUNT == 0) ? _TOTAL_TEETH_COUNT : (input % _TOTAL_TEETH_COUNT);

  Set<int> _filterSelectionToJaw(Set<int> toothSelection, Jaw jaw) {
    final (start, end) = jaw == Jaw.upper
        ? (_LEFT_MOST_UPPER_JAW_TOOTH, _RIGHT_MOST_UPPER_JAW_TOOTH)
        : (_RIGHT_MOST_LOWER_JAW_TOOTH, _LEFT_MOST_LOWER_JAW_TOOTH);

    return toothSelection.where((element) => element >= start && element <= end).toSet();
  }

  bool _isInTheSameRow(Set<int> toothSet) => _allTeethInUpperJaw(toothSet) || _allTeethInLowerJaw(toothSet);

  Jaw _getJawOfToothBlock(Set<int> toothSet) => _allTeethInUpperJaw(selectedTeeth) ? Jaw.upper : Jaw.lower;

  bool _allTeethInUpperJaw(Set<int> toothSet) => toothSet.every((element) => element <= _RIGHT_MOST_UPPER_JAW_TOOTH);

  bool _allTeethInLowerJaw(Set<int> toothSet) => toothSet.every((element) => element >= _RIGHT_MOST_LOWER_JAW_TOOTH);
}
