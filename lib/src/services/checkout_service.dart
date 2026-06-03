import '../models/checkout.dart';
import 'base_service.dart';

/// Collections via Fincra's hosted checkout.
///
/// Accessed via `fincra.checkout`.
class CheckoutService extends BaseService {
  const CheckoutService(super.client);

  /// Creates a hosted checkout and returns the link to open.
  ///
  /// `POST /checkout/payments` (sends `x-pub-key`).
  ///
  /// Open [CheckoutSession.link] in a WebView/browser. After the customer
  /// pays, confirm the outcome with [verify] or, preferably, a webhook —
  /// the browser redirect is not a trustworthy source of truth.
  Future<CheckoutSession> initiate(CheckoutRequest request) async {
    final body = await client.post(
      '/checkout/payments',
      body: request.toJson(),
      includePublicKey: true,
    );
    return CheckoutSession.fromJson(
      (body['data'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// Verifies a checkout by your [reference].
  ///
  /// `GET /checkout/payments/merchant-reference/{reference}`
  ///
  /// Returns the raw `data` map; the exact fields depend on the payment
  /// method, but `status` tells you whether the payment succeeded.
  Future<Map<String, dynamic>> verify(String reference) async {
    final body = await client.get(
      '/checkout/payments/merchant-reference/$reference',
    );
    return (body['data'] as Map<String, dynamic>?) ?? const {};
  }
}
