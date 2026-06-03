import '../models/bank.dart';
import 'base_service.dart';


class BanksService extends BaseService {
  const BanksService(super.client);

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
