import '../core/fincra_config.dart';
import '../models/payout.dart';
import 'base_service.dart';


class PayoutsService extends BaseService {
  const PayoutsService(super.client, this._config);

  final FincraConfig _config;

  Future<Payout> initiate(PayoutRequest request) async {
    final business = request.business ?? _config.businessId;
    final payload = request.toJson();
    if (business != null) payload['business'] = business;

    final body = await client.post('/disbursements/payouts', body: payload);
    return Payout.fromJson((body['data'] as Map<String, dynamic>?) ?? const {});
  }

  
  Future<Payout> verify(String reference) async {
    final body =
        await client.get('/disbursements/payouts/reference/$reference');
    return Payout.fromJson((body['data'] as Map<String, dynamic>?) ?? const {});
  }
}
