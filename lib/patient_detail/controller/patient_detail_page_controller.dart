import 'package:rover/common/error/connection_exception.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/patient/model/treatment.dart';
import 'package:rover/patient/model/treatment_plan.dart';
import 'package:rover/patient_detail/model/tooth_image_sort_type.dart';
import 'package:rover/pms_connection/contract/pms_connection_service.dart';
import 'package:rxdart/rxdart.dart';

const _DEFAULT_TEETH_SORT_TYPE = ToothImageSortType.imageNewToOld;

class PatientDetailPageController {
  final _dialogController = get<ImageCaptureDialogController>();
  final _treatmentPlans = BehaviorSubject<List<TreatmentPlan>?>();
  final _treatments = BehaviorSubject<List<Treatment>?>();
  final _selectedTeeth = BehaviorSubject<Set<int>>();
  final _missingTeeth = BehaviorSubject<Set<int>>();
  final _imagesSortType = BehaviorSubject<ToothImageSortType>();
  final PMSConnectionService pmsConnectionService;
  String? _patientId;
  String? _treatmentPlanId;

  PatientDetailPageController({required this.pmsConnectionService});

  Stream<List<TreatmentPlan>?> get treatmentPlansStream => _treatmentPlans.stream;

  Stream<List<Treatment>?> get treatmentsStream => _treatments.stream;

  Stream<Set<int>> get selectedTeethStream => _selectedTeeth.stream;

  Stream<Set<int>> get missingTeethStream => _missingTeeth.stream;

  Stream<ToothImageSortType> get imageSortType => _imagesSortType.stream;

  void setPatientId(String id) {
    _treatmentPlans.add(null);
    _selectedTeeth.add({});
    _imagesSortType.add(_DEFAULT_TEETH_SORT_TYPE);
    _treatmentPlanId = null;
    _patientId = id;
    refreshPatientDetails();
  }

  void setTreatmentPlanId(String id) {
    _treatments.add(null);
    _treatmentPlanId = id;
    refreshPatientDetails();
  }

  void setSelectedTeeth(Set<int> selectedTeeth) => _selectedTeeth.add(selectedTeeth);

  void filterSelectedTeethUsingAvailableTeeth(Set<int> availableTeeth) {
    _selectedTeeth.add(_selectedTeeth.value.intersection(availableTeeth));
  }

  void setImageSortType(ToothImageSortType sortType) => _imagesSortType.add(sortType);

  Future<void> refreshPatientDetails() async {
    try {
      if (_patientId != null) {
        final treatmentPlans = await pmsConnectionService.getTreatmentPlansByPatientId(_patientId!);
        _treatmentPlans.add(treatmentPlans);

        final toothInitials = await pmsConnectionService.getToothInitialsByPatientId(_patientId!);
        final missingTeeth =
            toothInitials.where((element) => element.initialType == 'Missing').map((e) => e.toothNum).toSet();
        _missingTeeth.add(missingTeeth);
        _dialogController.initialMissingTeeth = missingTeeth;

        if (_treatmentPlanId != null) {
          final treatments = await pmsConnectionService.getTreatmentsByTreatmentPlanId(_treatmentPlanId!);
          _treatments.add(treatments);
        }
      }
    } catch (e) {
      e is ConnectionException
          ? showErrorSnackbarWithClose(title: 'Error while fetching treatments and treatment plans', content: e.message)
          : showErrorSnackbarWithClose(title: 'Unexpected error occurred while fetching data', content: e.toString());
      _treatments.addError(e);
      _treatmentPlans.addError(e);
    }
  }
}
