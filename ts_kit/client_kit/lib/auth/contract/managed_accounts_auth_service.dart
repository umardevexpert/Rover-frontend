import 'package:client_kit/auth/contract/auth_service.dart';
import 'package:client_kit/auth/model/auth_result.dart';
import 'package:client_kit/auth/model/managed_accounts_failure/create_account_failure.dart';
import 'package:client_kit/auth/model/managed_accounts_failure/delete_account_failure.dart';
import 'package:client_kit/auth/model/managed_accounts_failure/username_sign_in_failure.dart';
import 'package:client_kit/auth/model/shared_auth_failure/change_password_failure.dart';
import 'package:master_kit/contracts/identifiable.dart';

abstract interface class ManagedAccountsAuthService<TUserDetails extends Identifiable>
    implements AuthService<TUserDetails> {
  Future<AuthResult<CreateAccountFailure>> createAccount(
    String username,
    String password,
    TUserDetails userDetails,
  );
  Future<AuthResult<UsernameSignInFailure>> signInWithUserNameAndPassword(String username, String password);
  Future<AuthResult<ChangePasswordFailure>> changePassword(String oldPassword, String newPassword);
  Future<AuthResult<DeleteAccountFailure>> deleteAccount(String accountId);
}
