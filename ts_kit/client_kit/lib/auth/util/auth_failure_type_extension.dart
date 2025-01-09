import 'package:client_kit/auth/model/auth_failure_type.dart';

// WARNING(riso): When you edit messages here, keep in mind that you need to edit the messages in temporary localization service and failure message presenter
const _AUTH_FAILURE_TO_UI_MESSAGE = {
  AuthFailureType.userDisabled: 'Your account is temporarily unavailable.',
  AuthFailureType.userNotFound:
      'Account with given username does not exist. Please check for typos or sign up instead.',
  AuthFailureType.wrongPassword: 'Incorrect password. Please try again.',
  AuthFailureType.weakPassword:
      'Such password is insecure. Use at least 8 characters, one digit, one uppercase and one lowercase letter.',
  AuthFailureType.userNotLoggedIn: 'You have been logged out. Please login and try again.',

  // For auth services that uses links (e. g. firebase)
  AuthFailureType.expiredActionCode:
      'The link you have used has expired or has already been used. Please request a new link.',
  AuthFailureType.malformedLink:
      'The link you have used is in incorrect format. Please use a valid link and make sure it is not changed.',
  AuthFailureType.invalidActionCode: 'The link you have used has already been used. Please request a new link.',

  // For email auth service
  AuthFailureType.emailNotRegistered:
      'There is no account associated with this email. Please check for typos or sign up instead.',
  AuthFailureType.invalidEmail: 'Please enter a valid email address.',
  AuthFailureType.emailAlreadyInUse: 'An account with this email already exists. Please sign in instead.',

  // For managed accounts auth service
  AuthFailureType.invalidUsername: 'Username is in incorrect format. Try using only letters and numbers.',
  AuthFailureType.usernameAlreadyInUse: 'An account with this username already exists. Please sign in instead.',
  AuthFailureType.accountNotFound: 'The account that you are trying to modify does not exist.',
  AuthFailureType.noPermissionToCreateAccounts: 'You do not have permission to create accounts.',
  AuthFailureType.noPermissionToDeleteAccounts: 'You do not have permission to delete accounts.',

  // For access token enabled auth services
  AuthFailureType.accessTokenNotFoundOrAssigned:
      'Access card or other token you have used was not found. Assign it to an account first.',
  AuthFailureType.tokenSecretAlreadyInUse: 'Card or other access token you are trying to assign is already assigned.',
  AuthFailureType.invalidTokenSecret: 'This card or other access token is deficient. Please use another one.',
  AuthFailureType.accessTokenNotFound: 'Card or other access token you have used was not found.',
  AuthFailureType.noPermissionToAssignAccessToken:
      'You do not have permission to assign cards or access tokens to user.',
  AuthFailureType.noPermissionToDeleteAccessToken: 'You do not have permission to delete cards or access tokens.',

  // Common errors that may occur in communication
  AuthFailureType.other:
      'Something went wrong. Please check your internet connection, then try again. If the issue is not resolved within an hour, please contact our support.',
  AuthFailureType.tooManyRequests: 'Too many recent login attempts. Reset your password or try again later.',
  AuthFailureType.userAuthorizationRequestFailed: 'An error occurred while requesting your access permissions.',
  AuthFailureType.connectionFailure: 'Internet connection was lost. Try again later.',
};

extension AuthFailureExtension on AuthFailureType {
  String get defaultUIMessage => _AUTH_FAILURE_TO_UI_MESSAGE[this]!;
}
