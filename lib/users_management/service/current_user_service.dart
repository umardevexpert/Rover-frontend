import 'package:client_kit/auth/model/current_user.dart';
import 'package:client_kit/auth/service/auth_dependent_stream_controller.dart';
import 'package:database_kit/collection_read_write/collection_repository.dart';
import 'package:rover/auth/model/access_data.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/users_management/model/user.dart';

class UserProfileService extends AuthDependentStreamController<RoverUserDetails, User> {
  final CollectionRepository<User> _userRepository;

  Stream<User?> get userProfileStream => stream;

  UserProfileService({required super.authService, required CollectionRepository<User> userRepository})
      : _userRepository = userRepository;

  @override
  Stream<User?>? obtainStreamWhenLoggedIn(CurrentUser<AccessData> currentUser) {
    return _userRepository.observeDocument(currentUser.id);
  }

  Future<void> setCurrentUserHasChangedPassword({required bool hasChanged}) async {
    final updatedUser = value!.copyWith(hasChangedInitialPassword: hasChanged);
    await _userRepository.createOrReplace(updatedUser, updatedUser.id);
  }
}
