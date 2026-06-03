import '../models/resolved_account.dart';
import 'base_service.dart';


class VerificationService extends BaseService {
  const VerificationService(super.client);


  Future<ResolvedAccount> resolveAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    final body = await client.post(
      '/core/accounts/resolve',
      body: {
        'accountNumber': accountNumber,
        'bankCode': bankCode,
        'type': 'nuban',
      },
    );
    return ResolvedAccount.fromJson(
      (body['data'] as Map<String, dynamic>?) ?? const {},
    );
  }
}
