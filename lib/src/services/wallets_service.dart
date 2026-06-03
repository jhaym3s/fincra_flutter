import '../models/business.dart';
import '../models/wallet.dart';
import 'base_service.dart';

/// Wallet balances and business profile.
///
/// Accessed via `fincra.wallets`.
class WalletsService extends BaseService {
  const WalletsService(super.client);

  /// Lists all currency balances on the account.
  ///
  /// `GET /wallets`
  Future<List<Wallet>> list() async {
    final body = await client.get('/wallets');
    final dynamic data = body['data'];
    final list = data is List ? data : const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(Wallet.fromJson)
        .toList(growable: false);
  }

  /// Fetches this account's business profile.
  ///
  /// `GET /profile/business/me`
  ///
  /// Handy for retrieving the business id required by other endpoints.
  Future<Business> me() async {
    final body = await client.get('/profile/business/me');
    return Business.fromJson(
      (body['data'] as Map<String, dynamic>?) ?? const {},
    );
  }
}
