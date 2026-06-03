import '../models/business.dart';
import '../models/wallet.dart';
import 'base_service.dart';

class WalletsService extends BaseService {
  const WalletsService(super.client);

 
  Future<List<Wallet>> list() async {
    final body = await client.get('/wallets');
    final dynamic data = body['data'];
    final list = data is List ? data : const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(Wallet.fromJson)
        .toList(growable: false);
  }

  Future<Business> me() async {
    final body = await client.get('/profile/business/me');
    return Business.fromJson(
      (body['data'] as Map<String, dynamic>?) ?? const {},
    );
  }
}
