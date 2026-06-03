import '../core/fincra_config.dart';
import '../models/payout.dart';
import 'base_service.dart';

/// Payouts / disbursements to bank accounts and mobile money wallets.
///
/// Accessed via `fincra.payouts`.
class PayoutsService extends BaseService {
  const PayoutsService(super.client, this._config);

  final FincraConfig _config;

  /// Initiates a payout.
  ///
  /// `POST /disbursements/payouts`
  ///
  /// If [PayoutRequest.business] is null, the client's configured
  /// `businessId` is used. The returned [Payout.reference] is what you pass
  /// to [verify]. Only payouts with status `failed` should be retried — a
  /// timeout does not necessarily mean the payout failed.
  Future<Payout> initiate(PayoutRequest request) async {
    final business = request.business ?? _config.businessId;
    final payload = request.toJson();
    if (business != null) payload['business'] = business;

    final body = await client.post('/disbursements/payouts', body: payload);
    return Payout.fromJson((body['data'] as Map<String, dynamic>?) ?? const {});
  }

  /// Verifies a payout by its transaction [reference].
  ///
  /// `GET /disbursements/payouts/reference/{reference}`
  Future<Payout> verify(String reference) async {
    final body =
        await client.get('/disbursements/payouts/reference/$reference');
    return Payout.fromJson((body['data'] as Map<String, dynamic>?) ?? const {});
  }
}
