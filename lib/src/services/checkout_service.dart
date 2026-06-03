import '../models/checkout.dart';
import 'base_service.dart';


class CheckoutService extends BaseService {
  const CheckoutService(super.client);


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


  Future<Map<String, dynamic>> verify(String reference) async {
    final body = await client.get(
      '/checkout/payments/merchant-reference/$reference',
    );
    return (body['data'] as Map<String, dynamic>?) ?? const {};
  }
}
