import 'package:master_kit/contracts/identifiable.dart';

class InMemoryMockedAuthUser<TUserDetails extends Identifiable, TAccessToken extends Identifiable> {
  final String username;
  final String password;
  final TUserDetails details;
  final Map<String, TAccessToken> tokenCodeToToken;

  InMemoryMockedAuthUser({
    required this.username,
    required this.password,
    required this.details,
    Map<String, TAccessToken>? tokenCodeToToken,
  }) : tokenCodeToToken = tokenCodeToToken ?? {};
}
