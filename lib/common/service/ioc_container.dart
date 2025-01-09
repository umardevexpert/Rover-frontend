import 'package:client_kit/auth/contract/managed_accounts_access_token_enabled_auth_service.dart';
import 'package:client_kit/auth/model/current_user.dart';
import 'package:client_kit/auth/service/in_memory_auth_service.dart';
import 'package:database_kit/collection_read_write/collection_repository.dart';
import 'package:database_kit/ioc_extension/get_it_collection_repo_extension.dart';
import 'package:database_kit/local_collection_repository/in_memory_collection_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:master_kit/contracts/identifiable.dart';
import 'package:master_kit/util/platform.dart';
import 'package:rover/admin_settings/model/pms_settings.dart';
import 'package:rover/auth/model/access_data.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/image_capturing/contract/intra_oral_camera_service.dart';
import 'package:rover/image_capturing/service/audio_player_controller.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/service/intra_oral_camera_button_press_service.dart';
import 'package:rover/image_capturing/service/tooth_image_storage_controller.dart';
import 'package:rover/open_dental_connection/models/open_dental_appointment.dart';
import 'package:rover/open_dental_connection/models/open_dental_patient.dart';
import 'package:rover/open_dental_connection/models/open_dental_tooth_initials.dart';
import 'package:rover/open_dental_connection/models/open_dental_treatment.dart';
import 'package:rover/open_dental_connection/models/open_dental_treatment_plan.dart';
import 'package:rover/open_dental_connection/service/open_dental_connection_service.dart';
import 'package:rover/open_dental_connection/service/open_dental_mapper.dart';
import 'package:rover/patient/model/patients_table_column_type.dart';
import 'package:rover/patient/service/patients_filtering_service.dart';
import 'package:rover/patient/service/patients_page_controller.dart';
import 'package:rover/patient/service/patients_table_controller.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:rover/pms_connection/contract/pms_connection_service.dart';
import 'package:rover/pms_connection/contract/pms_mapper.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/model/user_role.dart';
import 'package:rover/users_management/service/current_user_service.dart';
import 'package:rover/~test_data/test_users.dart';

final get = GetIt.I;
const TODAYS_APPOINTMENTS_INSTANCE_NAME = 'TodaysAppointments';
const ALL_PATIENTS_INSTANCE_NAME = 'AllPatients';

typedef RoverUserDetails = CurrentUser<AccessData>;
typedef UserAuthService = ManagedAccountsAccessTokenEnabledAuthService<RoverUserDetails, Identifiable>;

final _inMemoryAuth = InMemoryAuthService<RoverUserDetails, Identifiable>(mockedUsers: TestUsers.users);

class IoCContainer {
  void setup() {
    get.registerCollectionRepoAsSingleton<User, CollectionRepository<User>>(
      InMemoryCollectionRepository<User>(
        mapper: User.fromJson,
        seed: {
          '1': User(
            id: '1',
            name: 'Jacob',
            surname: 'A',
            role: UserRole.admin,
            email: 'jacob@admin.com',
            phone: '0123456789',
            pictureURL:
                'https://media.licdn.com/dms/image/D4D03AQH5DvQGgPKTiw/profile-displayphoto-shrink_800_800/0/1631815685230?e=2147483647&v=beta&t=KMvn8ryMJizZMYpBm0uBRvluX2zu48w78spHZ6XkltU',
            hasChangedInitialPassword: true,
            joinDate: DateTime(2023, 3, 16),
          ),
          '2': User(
            id: '2',
            name: 'Jacob',
            surname: 'D',
            role: UserRole.doctor,
            email: 'jacob@doctor.com',
            phone: '0123456789',
            pictureURL: null,
            hasChangedInitialPassword: true,
            joinDate: DateTime(2023, 4, 1),
          ),
          '3': User(
            id: '3',
            name: 'Ngu',
            surname: 'Mbandi',
            role: UserRole.admin,
            email: 'ngu@mymetrodental.com',
            phone: '123-456-7890',
            pictureURL:
                'https://media.licdn.com/dms/image/D4D03AQH5DvQGgPKTiw/profile-displayphoto-shrink_800_800/0/1631815685230?e=2147483647&v=beta&t=KMvn8ryMJizZMYpBm0uBRvluX2zu48w78spHZ6XkltU',
            hasChangedInitialPassword: true,
            joinDate: DateTime(2023, 8, 18),
          ),
        },
      ),
    );
    get.registerSingleton(ToothImageStorageController());
    get.registerSingleton<UserAuthService>(_inMemoryAuth);
    get.registerSingleton(
      UserProfileService(
        authService: get<UserAuthService>(),
        userRepository: get<CollectionRepository<User>>(),
      ),
    );
    get.registerCollectionRepoAsSingleton<PMSSettings, CollectionRepository<PMSSettings>>(
      InMemoryCollectionRepository(
        mapper: PMSSettings.fromJson,
        seed: {
          // '1': PMSSettings(id: '1', apiKey: '127384302382DEYRJSNBHhsbagsh', ipAddress: '127.0.0.1'),
          '1': PMSSettings(
            id: '1',
            developerKey: 'NFF6i0KrXrxDkZHt',
            customerKey: 'VzkmZEaUWOjnQX2z',
            ipAddress: 'https://api.opendental.com',
          ),
        },
      ),
    );
    get.registerSingleton<
        PMSMapper<OpenDentalPatient, OpenDentalAppointment, OpenDentalTreatmentPlan, OpenDentalTreatment,
            OpenDentalToothInitials>>(
      OpenDentalMapper(),
    );
    get.registerSingleton<PMSConnectionService>(
      OpenDentalConnectionService(
        mapper: get<
            PMSMapper<OpenDentalPatient, OpenDentalAppointment, OpenDentalTreatmentPlan, OpenDentalTreatment,
                OpenDentalToothInitials>>(),
        settingsRepository: get<CollectionRepository<PMSSettings>>(),
      ),
    );
    get.registerSingleton(ImageCaptureDialogController(get<ToothImageStorageController>()));
    get.registerSingleton(PatientDetailPageController(pmsConnectionService: get<PMSConnectionService>()));
    get.registerSingleton(
      PatientsTableController(
        initialSortColumn: PatientsTableColumnType.status,
        initialSortingType: TableSortingType.ascending,
      ),
      instanceName: TODAYS_APPOINTMENTS_INSTANCE_NAME,
    );
    get.registerSingleton(
      PatientsTableController(
        initialSortColumn: PatientsTableColumnType.name,
        initialSortingType: TableSortingType.ascending,
      ),
      instanceName: ALL_PATIENTS_INSTANCE_NAME,
    );
    get.registerSingleton(PatientsFilteringService());
    get.registerSingleton(
      PatientsPageController(
        get<PatientsFilteringService>(),
        get<PMSConnectionService>(),
        get<PatientsTableController>(instanceName: ALL_PATIENTS_INSTANCE_NAME),
        get<PatientsTableController>(instanceName: TODAYS_APPOINTMENTS_INSTANCE_NAME),
      ),
    );
    switch (Platform.current) {
      case Platform.macOS:
        get.registerSingleton<IntraOralCameraService>(MacOsIntraOralCameraService());
        break;
      default:
        get.registerSingleton<IntraOralCameraService>(WindowsIntraOralCameraService());
    }
    get.registerSingleton(AudioPlayerController());
    get.registerSingleton(
        IntraOralCameraButtonPressService(get<ImageCaptureDialogController>(), get<AudioPlayerController>()));
  }
}
