import 'dart:convert';

import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

/// Builds a Fincra client whose HTTP layer is backed by [handler], so no real
/// network calls are made.
Fincra clientWith(Future<http.Response> Function(http.Request) handler) {
  return Fincra(
    secretKey: 'sk_test_x',
    publicKey: 'pk_test_x',
    businessId: 'biz_123',
    httpClient: MockClient((req) => handler(req)),
  );
}

http.Response json(Object body, {int status = 200}) =>
    http.Response(jsonEncode(body), status, headers: {
      'content-type': 'application/json',
    });

void main() {
  group('auth + URLs', () {
    test('sends api-key and targets the sandbox base url', () async {
      late http.Request captured;
      final fincra = clientWith((req) async {
        captured = req;
        return json({
          'success': true,
          'message': 'ok',
          'data': [],
        });
      });

      await fincra.banks.list(currency: 'NGN', country: 'NG');

      expect(captured.headers['api-key'], 'sk_test_x');
      expect(captured.url.origin, 'https://sandboxapi.fincra.com');
      expect(captured.url.path, '/core/banks');
      expect(captured.url.queryParameters['currency'], 'NGN');
      fincra.close();
    });

    test('checkout includes x-pub-key header', () async {
      late http.Request captured;
      final fincra = clientWith((req) async {
        captured = req;
        return json({
          'status': true,
          'message': 'Hosted link generated',
          'data': {
            'link': 'https://sandbox-checkout.fincra.com/pay/fcr-p-1',
            'reference': 'KB-909',
            'payCode': 'fcr-p-1',
          },
        });
      });

      final session = await fincra.checkout.initiate(
        const CheckoutRequest(
          amount: 1500,
          currency: 'NGN',
          customer: FincraCustomer(name: 'Ada Lovelace', email: 'a@b.com'),
        ),
      );

      expect(captured.headers['x-pub-key'], 'pk_test_x');
      expect(session.reference, 'KB-909');
      expect(session.link, contains('/pay/'));
      fincra.close();
    });
  });

  group('parsing', () {
    test('resolveAccount parses name and number', () async {
      final fincra = clientWith((req) async => json({
            'success': true,
            'message': 'Account resolve successful',
            'data': {'accountNumber': '4038373314', 'accountName': 'Mart Olumide'},
          }));

      final acct = await fincra.verification.resolveAccount(
        accountNumber: '4038373314',
        bankCode: '044',
      );

      expect(acct.accountName, 'Mart Olumide');
      expect(acct.accountNumber, '4038373314');
      fincra.close();
    });

    test('payout exposes status helpers', () async {
      final fincra = clientWith((req) async => json({
            'success': true,
            'message': 'ok',
            'data': {'reference': 'db39', 'status': 'successful'},
          }));

      final payout = await fincra.payouts.initiate(
        const PayoutRequest(
          amount: 900,
          sourceCurrency: 'NGN',
          destinationCurrency: 'NGN',
          customerReference: 'ref-1',
          beneficiary: Beneficiary(
            firstName: 'John',
            lastName: 'Doe',
            accountHolderName: 'John Doe',
            accountNumber: '1006219020',
            type: 'individual',
            country: 'NG',
            bankCode: '044',
          ),
        ),
      );

      expect(payout.isSuccessful, isTrue);
      expect(payout.isFailed, isFalse);
      fincra.close();
    });
  });

  group('errors', () {
    test('maps a 422 error body to FincraException', () async {
      final fincra = clientWith((req) async => json({
            'success': false,
            'error': 'Account could not be resolved',
            'errorType': 'UNPROCESSABLE_ENTITY',
          }, status: 422));

      expect(
        () => fincra.verification
            .resolveAccount(accountNumber: '1', bankCode: '044'),
        throwsA(isA<FincraException>()
            .having((e) => e.statusCode, 'statusCode', 422)
            .having((e) => e.errorType, 'errorType', 'UNPROCESSABLE_ENTITY')),
      );
      fincra.close();
    });

    test('treats success:false on a 200 as a failure', () async {
      final fincra = clientWith((req) async => json({
            'success': false,
            'message': 'nope',
          }));

      expect(
        () => fincra.banks.list(),
        throwsA(isA<FincraException>()),
      );
      fincra.close();
    });
  });
}
