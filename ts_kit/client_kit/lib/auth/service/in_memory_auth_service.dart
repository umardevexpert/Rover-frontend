import 'dart:async';

import 'package:client_kit/auth/contract/managed_accounts_access_token_enabled_auth_service.dart';
import 'package:client_kit/auth/model/access_token_failure/assign_access_token_failure.dart';
import 'package:client_kit/auth/model/access_token_failure/auth_state_change_via_token_secret_failure.dart';
import 'package:client_kit/auth/model/access_token_failure/delete_access_token_failure.dart';
import 'package:client_kit/auth/model/access_token_failure/validate_token_secret_result.dart';
import 'package:client_kit/auth/model/auth_event.dart';
import 'package:client_kit/auth/model/auth_event_type.dart';
import 'package:client_kit/auth/model/auth_result.dart';
import 'package:client_kit/auth/model/auth_state.dart';
import 'package:client_kit/auth/model/in_memory_mocked_auth_user.dart';
import 'package:client_kit/auth/model/managed_accounts_failure/create_account_failure.dart';
import 'package:client_kit/auth/model/managed_accounts_failure/delete_account_failure.dart';
import 'package:client_kit/auth/model/managed_accounts_failure/username_sign_in_failure.dart';
import 'package:client_kit/auth/model/shared_auth_failure/change_password_failure.dart';
import 'package:client_kit/auth/model/token_secret_auth_change_options.dart';
import 'package:collection/collection.dart';
import 'package:master_kit/contracts/identifiable.dart';
import 'package:master_kit/sdk_extension/object_extension.dart';
import 'package:master_kit/sdk_extension/stream_extension.dart';
import 'package:rxdart/rxdart.dart';

typedef _UsernameWithPassword = ({String username, String password});

class InMemoryAuthService<TUserDetails extends Identifiable, TAccessToken extends Identifiable>
    implements ManagedAccountsAccessTokenEnabledAuthService<TUserDetails, TAccessToken> {
  final _authStreamController = BehaviorSubject<AuthState<TUserDetails>>.seeded(const InitialAuthState());
  final _eventStreamController = BehaviorSubject<AuthEvent<TUserDetails>>();

  late final Map<String, TUserDetails> _usernameToUser;
  late final Map<String, _UsernameWithPassword> _idToUsernameAndPassword;
  late final Map<String, ({String userId, TAccessToken token})> _accessTokenCodeToAccessTokenAndId;

  @override
  late final Stream<AuthState<TUserDetails>> authStream = _authStreamController.stream;

  @override
  late final Stream<AuthEvent<TUserDetails>> eventStream = _eventStreamController.stream;

  @override
  late final Stream<TUserDetails?> signedInUserStream;

  @override
  TUserDetails? get signedInUser =>
      _authStreamController.valueOrNull?.maybeSubtype<LoggedInAuthState<TUserDetails>>()?.user;

  InMemoryAuthService({List<InMemoryMockedAuthUser<TUserDetails, TAccessToken>> mockedUsers = const []}) {
    _usernameToUser = <String, TUserDetails>{};
    _idToUsernameAndPassword = <String, _UsernameWithPassword>{};
    _accessTokenCodeToAccessTokenAndId = <String, ({String userId, TAccessToken token})>{};
    signedInUserStream = authStream
        .map((authEvent) => authEvent is LoggedInAuthState<TUserDetails> ? authEvent.user : null)
        .asValueBroadcastStream();

    for (final mockedUser in mockedUsers) {
      final userId = mockedUser.details.id;

      _usernameToUser[mockedUser.username] = mockedUser.details;
      _idToUsernameAndPassword[userId] = (username: mockedUser.username, password: mockedUser.password);
      for (final tokenSecretWithAccessToken in mockedUser.tokenCodeToToken.entries) {
        _accessTokenCodeToAccessTokenAndId[tokenSecretWithAccessToken.key] =
            (userId: userId, token: tokenSecretWithAccessToken.value);
      }
    }
  }

  FutureOr<void> dispose() async {
    await _authStreamController.close();
    await _eventStreamController.close();
  }

  @override
  Future<AuthResult<UsernameSignInFailure>> signInWithUserNameAndPassword(String username, String password) {
    final user = _usernameToUser[username.toLowerCase()];
    if (user == null) {
      return Future.value(AuthResult.withError(UsernameSignInFailure.userNotFound));
    }

    final userPassword = _idToUsernameAndPassword[user.id]?.password;
    if (userPassword != password) {
      return Future.value(AuthResult.withError(UsernameSignInFailure.wrongPassword));
    }

    _addNewState(LoggedInAuthState(user));

    return Future.value(AuthResult.success());
  }

  @override
  Future<void> signOut() async {
    _addNewState(LoggedOutAuthState<TUserDetails>());
  }

  @override
  Future<AuthResult<DeleteAccountFailure>> deleteAccount(String accountId) async {
    if (signedInUser == null) {
      return Future.value(AuthResult.withError(DeleteAccountFailure.userNotLoggedIn));
    }

    _usernameToUser.removeWhere((_, value) => value.id == accountId);
    _idToUsernameAndPassword.remove(accountId);
    _accessTokenCodeToAccessTokenAndId.removeWhere((_, userToken) => userToken.userId == accountId);

    return Future.value(AuthResult.success());
  }

  @override
  Future<AuthResult<CreateAccountFailure>> createAccount(
    String username,
    String password,
    TUserDetails userDetails,
  ) {
    return _createAccountWithAuthRequest(username, password, userDetails);
  }

  Future<AuthResult<CreateAccountFailure>> _createAccountWithAuthRequest(
    String username,
    String password,
    TUserDetails newUser,
  ) async {
    if (!_validateUsername(username)) {
      return Future.value(AuthResult.withError(CreateAccountFailure.invalidUsername));
    }

    if (!_verifyPasswordStrength(password)) {
      return Future.value(AuthResult.withError(CreateAccountFailure.weakPassword));
    }

    final lowerCaseUsername = username.toLowerCase();
    final user = _usernameToUser[lowerCaseUsername];
    if (user != null) {
      return Future.value(AuthResult.withError(CreateAccountFailure.usernameAlreadyInUse));
    }

    _idToUsernameAndPassword[newUser.id] = (username: username, password: password);
    _usernameToUser[lowerCaseUsername] = newUser;

    return Future.value(AuthResult.success());
  }

  @override
  Future<AuthResult<ChangePasswordFailure>> changePassword(String oldPassword, String newPassword) async {
    final user = signedInUser;

    if (user == null) {
      return Future.value(AuthResult.withError(ChangePasswordFailure.userNotLoggedIn));
    }
    if (_idToUsernameAndPassword[user.id]?.password != oldPassword) {
      return Future.value(AuthResult.withError(ChangePasswordFailure.wrongPassword));
    }
    if (!_verifyPasswordStrength(newPassword)) {
      return Future.value(AuthResult.withError(ChangePasswordFailure.weakPassword));
    }
    final userData = _idToUsernameAndPassword[user.id]!;
    _idToUsernameAndPassword[user.id] = (username: userData.username, password: newPassword);
    return Future.value(AuthResult.success());
  }

  bool _validateUsername(String username) {
    if (username.isEmpty) {
      return false;
    }
    return true;
  }

  bool _verifyPasswordStrength(String password) =>
      password.length >= 8 &&
      password.contains(RegExp('[a-z]')) &&
      password.contains(RegExp('[A-Z]')) &&
      password.contains(RegExp('[0-9]'));

  void _addNewState(AuthState<TUserDetails> newState) {
    final currentState = _authStreamController.value;

    _eventStreamController.add(
      AuthEvent(type: AuthEventType.willChangeAuthState, previousState: currentState, newState: newState),
    );
    _authStreamController.add(newState);
    _eventStreamController.add(
      AuthEvent(type: AuthEventType.didChangeAuthState, previousState: currentState, newState: newState),
    );
  }

  @override
  Future<AuthResult<AssignAccessTokenFailure>> assignAccessTokenToUser(
    String userId,
    String tokenSecret,
    TAccessToken accessToken,
  ) async {
    if (signedInUser == null) {
      return Future.value(AuthResult.withError(AssignAccessTokenFailure.noPermissionToAssignAccessToken));
    }
    if (_accessTokenCodeToAccessTokenAndId[tokenSecret] != null) {
      return Future.value(AuthResult.withError(AssignAccessTokenFailure.tokenSecretAlreadyInUse));
    }
    if (_idToUsernameAndPassword[userId] == null) {
      return Future.value(AuthResult.withError(AssignAccessTokenFailure.accountNotFound));
    }

    _accessTokenCodeToAccessTokenAndId[tokenSecret] = (userId: userId, token: accessToken);
    return Future.value(AuthResult.success());
  }

  @override
  Future<AuthResult<DeleteAccessTokenFailure>> removeAccessToken(String tokenId) async {
    if (signedInUser == null) {
      return Future.value(AuthResult.withError(DeleteAccessTokenFailure.noPermissionToDeleteAccessToken));
    }

    final tokenSecret =
        _accessTokenCodeToAccessTokenAndId.entries.firstWhereOrNull((entry) => entry.value.token.id == tokenId)?.key;

    if (tokenSecret == null) {
      return Future.value(AuthResult.withError(DeleteAccessTokenFailure.accessTokenNotFound));
    }
    _accessTokenCodeToAccessTokenAndId.remove(tokenSecret);
    return Future.value(AuthResult.success());
  }

  @override
  Future<AuthResult<AuthStateChangeViaAccessTokenFailure>> changeAuthStateViaTokenSecret(
    String tokenSecret, {
    AccessTokenAuthChangeOptions authChangeOptions = AccessTokenAuthChangeOptions.signIn,
  }) async {
    return switch (authChangeOptions) {
      AccessTokenAuthChangeOptions.signIn => _signInViaTokenSecret(tokenSecret),
      AccessTokenAuthChangeOptions.signOutIfHolderIsSignedIn => _signOutIfTokenSecretBelongsToCurrentUser(tokenSecret),
      AccessTokenAuthChangeOptions.signOutIfHolderIsSignedInOrSignInDifferentUser =>
        _signOutOrSignInHolderOfToken(tokenSecret),
      AccessTokenAuthChangeOptions.automatic => throw UnimplementedError(
          'The method for AccessTokenAuthChangeOptions automatic is not implemented.',
        ),
    };
  }

  // TODO(jirka): Extend the validation logic - add validation for strength of token secret
  // then this method should be called from the assignAccessTokenToUser
  @override
  Future<AuthResult<ValidateTokenSecretResult>> validateTokenSecret(String tokenSecret) async {
    if (_accessTokenCodeToAccessTokenAndId[tokenSecret] != null) {
      return Future.value(AuthResult.withError(ValidateTokenSecretResult.tokenSecretAlreadyInUse));
    }
    return Future.value(AuthResult.success());
  }

  Future<AuthResult<AuthStateChangeViaAccessTokenFailure>> _signInViaTokenSecret(String tokenSecret) {
    if (tokenSecret.isEmpty) {
      return Future.value(AuthResult.withError(AuthStateChangeViaAccessTokenFailure.invalidTokenSecret));
    }
    final userId = _accessTokenCodeToAccessTokenAndId[tokenSecret]?.userId;

    if (userId == null) {
      return Future.value(AuthResult.withError(AuthStateChangeViaAccessTokenFailure.tokenSecretNotFound));
    }

    final username = _idToUsernameAndPassword[userId]?.username;
    final user = _usernameToUser[username];

    if (user == null) {
      return Future.value(AuthResult.withError(AuthStateChangeViaAccessTokenFailure.userNotFound));
    }

    _addNewState(LoggedInAuthState(user));

    return Future.value(AuthResult.success());
  }

  Future<AuthResult<AuthStateChangeViaAccessTokenFailure>> _signOutIfTokenSecretBelongsToCurrentUser(
    String tokenSecret,
  ) async {
    final userId = signedInUser?.id;

    if (userId != null) {
      final accessTokenAndUserId = _accessTokenCodeToAccessTokenAndId[tokenSecret];

      if (accessTokenAndUserId == null) {
        return Future.value(AuthResult.withError(AuthStateChangeViaAccessTokenFailure.tokenSecretNotFound));
      }

      if (accessTokenAndUserId.userId == userId) {
        await signOut();
        return AuthResult.success();
      }
    }
    return Future.value(AuthResult.withError(AuthStateChangeViaAccessTokenFailure.other));
  }

  Future<AuthResult<AuthStateChangeViaAccessTokenFailure>> _signOutOrSignInHolderOfToken(
    String tokenSecret,
  ) async {
    final signOutError = await _signOutIfTokenSecretBelongsToCurrentUser(tokenSecret);

    if (signOutError.isSuccess) {
      return AuthResult.success();
    }

    final accessTokenAndUserId = _accessTokenCodeToAccessTokenAndId[tokenSecret];

    if (accessTokenAndUserId == null) {
      return Future.value(AuthResult.withError(AuthStateChangeViaAccessTokenFailure.tokenSecretNotFound));
    }

    await signOut();
    final signInResult = await _signInViaTokenSecret(tokenSecret);

    return signInResult;
  }
}
