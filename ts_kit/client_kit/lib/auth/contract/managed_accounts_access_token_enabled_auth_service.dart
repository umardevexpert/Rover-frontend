import 'package:client_kit/auth/contract/access_token_enabled_auth_service.dart';
import 'package:client_kit/auth/contract/managed_accounts_auth_service.dart';
import 'package:master_kit/contracts/identifiable.dart';

abstract interface class ManagedAccountsAccessTokenEnabledAuthService<TUserDetails extends Identifiable,
        TAccessToken extends Identifiable>
    implements ManagedAccountsAuthService<TUserDetails>, AccessTokenEnabledAuthService<TUserDetails, TAccessToken> {}
