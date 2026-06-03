import '../models/bank.dart';
import 'base_service.dart';

/// Lists banks and mobile money operators.
///
/// Accessed via `fincra.banks`.
class BanksService extends BaseService {
  const BanksService(super.client);

  /// Returns the banks/mobile money operators available for [currency] in
  /// [country]. The returned `code` is what you pass as `bankCode` when
  /// building a [Beneficiary] for a payout.
  ///
  /// `GET /core/banks?currency=NGN&country=NG`
  Future<List<Bank>> list({
    String currency = 'NGN',
    String country = 'NG',
  }) async {
    final body = await client.get(
      '/core/banks',
      query: {'currency': currency, 'country': country},
    );
    final dynamic data = body['data'];
    final list = data is List ? data : const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(Bank.fromJson)
        .toList(growable: false);
  }
}
