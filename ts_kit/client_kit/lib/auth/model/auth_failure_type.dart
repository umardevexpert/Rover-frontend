enum AuthFailureType {
  userDisabled,

  /// This type is used when a user is trying to access account that does not exist (and it's their account).
  userNotFound,
  wrongPassword,
  weakPassword,
  userNotLoggedIn,

  // For auth services that uses links (e. g. firebase)
  expiredActionCode,
  invalidActionCode,
  malformedLink,

  // For email auth service
  invalidEmail,
  emailAlreadyInUse,

  /// Similar to user not found, only the account is identified by email (not by username).
  emailNotRegistered,

  // For managed accounts auth service
  /// The message for this auth failure should be specific for each application
  invalidUsername,
  usernameAlreadyInUse,

  /// This type is used when account that is not current user's account is not found.
  accountNotFound,
  noPermissionToCreateAccounts,
  noPermissionToDeleteAccounts,
  userAuthorizationRequestFailed,

  // For access token enabled auth services
  /// Different from accessTokenNotFound: used for log in - the token must not only exist but also be assigned
  accessTokenNotFoundOrAssigned,
  tokenSecretAlreadyInUse,

  ///  e.g. empty token or too short token
  invalidTokenSecret,

  /// used in delete. Different from accessTokenNotFound: Message tells only that the token was not found, not
  /// that it might not be assigned
  accessTokenNotFound,
  noPermissionToAssignAccessToken,
  noPermissionToDeleteAccessToken,

  // Common errors that may occur in communication
  tooManyRequests,
  connectionFailure,
  other;
}
