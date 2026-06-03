import 'package:http/http.dart' as http;

import 'core/fincra_config.dart';
import 'core/fincra_environment.dart';
import 'core/fincra_http_client.dart';
import 'services/banks_service.dart';
import 'services/checkout_service.dart';
import 'services/payouts_service.dart';
import 'services/verification_service.dart';
import 'services/wallets_service.dart';

/// Entry point to the Fincra SDK.
///
/// Construct once and reuse. Services are exposed as fields:
///
/// ```dart
/// final fincra = Fincra(
///   secretKey: 'sk_test_...',
///   publicKey: 'pk_test_...',
///   businessId: '63da...e200',
///   environment: FincraEnvironment.sandbox,
/// );
///
/// final banks = await fincra.banks.list(currency: 'NGN');
/// final account = await fincra.verification.resolveAccount(
///   accountNumber: '0690000040', bankCode: '044',
/// );
/// ```
///
/// Call [close] when you are done to release the underlying HTTP client.
class Fincra {
  /// Creates a client from individual credentials.
  Fincra({
    required String secretKey,
    String? publicKey,
    String? businessId,
    FincraEnvironment environment = FincraEnvironment.sandbox,
    Duration timeout = const Duration(seconds: 30),
    http.Client? httpClient,
  }) : this.fromConfig(
          FincraConfig(
            secretKey: secretKey,
            publicKey: publicKey,
            businessId: businessId,
            environment: environment,
            timeout: timeout,
          ),
          httpClient: httpClient,
        );

  /// Creates a client from a [FincraConfig].
  Fincra.fromConfig(this.config, {http.Client? httpClient})
      : _http = FincraHttpClient(config, httpClient: httpClient) {
    banks = BanksService(_http);
    verification = VerificationService(_http);
    checkout = CheckoutService(_http);
    payouts = PayoutsService(_http, config);
    wallets = WalletsService(_http);
  }

  final FincraConfig config;
  final FincraHttpClient _http;

  /// List banks / mobile money operators.
  late final BanksService banks;

  /// Resolve (verify) account numbers.
  late final VerificationService verification;

  /// Collections via hosted checkout.
  late final CheckoutService checkout;

  /// Payouts / disbursements.
  late final PayoutsService payouts;

  /// Wallet balances and business profile.
  late final WalletsService wallets;

  /// Releases the underlying HTTP client.
  void close() => _http.close();
}
