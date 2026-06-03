import '../models/resolved_account.dart';
import 'base_service.dart';

/// Account verification (name enquiry).
///
/// Accessed via `fincra.verification`.
class VerificationService extends BaseService {
  const VerificationService(super.client);

  /// Resolves a NUBAN account to its account holder name.
  ///
  /// `POST /core/accounts/resolve`
  ///
  /// Use this to confirm a beneficiary before initiating a payout, so you can
  /// show the user the resolved name and avoid sending to the wrong account.
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
