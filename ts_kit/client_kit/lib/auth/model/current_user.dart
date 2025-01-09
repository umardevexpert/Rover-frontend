import 'package:master_kit/contracts/identifiable.dart';
import 'package:master_kit/util/random_id_generator.dart';

class CurrentUser<TAccessInfo> extends IdentifiableBase {
  final String? email;
  String? displayName;
  final bool isAnonymous;
  final TAccessInfo? accessInfo;

  CurrentUser(String id, this.email, this.displayName, this.isAnonymous, this.accessInfo) : super(id: id);

  factory CurrentUser.newUser(String? email, bool isAnonymous) {
    return CurrentUser(generateRandomString(length: LONG_ID_LENGTH), email, null, isAnonymous, null);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          isAnonymous == other.isAnonymous &&
          accessInfo == other.accessInfo;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ isAnonymous.hashCode ^ accessInfo.hashCode;

  @override
  String toString() {
    return 'CurrentUser{id: $id, email: $email, displayName: $displayName, isAnonymous: $isAnonymous, '
        'accessInfo: $accessInfo';
  }

  CurrentUser<TAccessInfo> copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? isAnonymous,
    TAccessInfo? accessInfo,
  }) {
    return CurrentUser<TAccessInfo>(
      id ?? this.id,
      email ?? this.email,
      displayName ?? this.displayName,
      isAnonymous ?? this.isAnonymous,
      accessInfo ?? this.accessInfo,
    );
  }
}
