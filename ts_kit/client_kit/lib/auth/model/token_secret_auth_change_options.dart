enum AccessTokenAuthChangeOptions {
  signIn,
  signOutIfHolderIsSignedIn,
  signOutIfHolderIsSignedInOrSignInDifferentUser,

  /// If no user is signed in: user will be signed in
  /// If user is signed in: if received access token belongs to currently signed in user, it will sign him out.
  /// Otherwise a user whose access token belong to will be signed in.
  automatic,
}
