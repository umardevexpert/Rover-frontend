import 'package:client_kit/auth/contract/auth_service.dart';
import 'package:client_kit/auth/model/access_token_failure/assign_access_token_failure.dart';
import 'package:client_kit/auth/model/access_token_failure/auth_state_change_via_token_secret_failure.dart';
import 'package:client_kit/auth/model/access_token_failure/delete_access_token_failure.dart';
import 'package:client_kit/auth/model/access_token_failure/validate_token_secret_result.dart';
import 'package:client_kit/auth/model/auth_result.dart';
import 'package:client_kit/auth/model/token_secret_auth_change_options.dart';
import 'package:master_kit/contracts/identifiable.dart';

abstract interface class AccessTokenEnabledAuthService<TUserDetails extends Identifiable,
    TAccessToken extends Identifiable> implements AuthService<TUserDetails> {
  Future<AuthResult<AssignAccessTokenFailure>> assignAccessTokenToUser(
    String userId,
    String tokenSecret,
    TAccessToken accessToken,
  );
  Future<AuthResult<AuthStateChangeViaAccessTokenFailure>> changeAuthStateViaTokenSecret(
    String tokenSecret, {
    AccessTokenAuthChangeOptions authChangeOptions = AccessTokenAuthChangeOptions.signIn,
  });

  Future<AuthResult<DeleteAccessTokenFailure>> removeAccessToken(String tokenId);

  Future<AuthResult<ValidateTokenSecretResult>> validateTokenSecret(String tokenSecret);
}
