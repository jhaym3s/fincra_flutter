# fincra_flutter

An unofficial Flutter/Dart SDK for the [Fincra](https://fincra.com) payment
infrastructure API. It wraps the endpoints most apps need:

- **Collections** — hosted checkout (`/checkout/payments`)
- **Payouts** — disbursements to banks & mobile money (`/disbursements/payouts`)
- **Verification** — resolve account numbers (`/core/accounts/resolve`)
- **Banks** — list banks & mobile money operators (`/core/banks`)
- **Wallets** — balances and business profile

> Not affiliated with or endorsed by Fincra. Endpoint shapes follow the public
> Fincra API docs at the time of writing.

## Install

```yaml
dependencies:
  fincra_flutter:
    git: https://github.com/your-org/fincra_flutter.git
```

## Quick start

```dart
import 'package:fincra_flutter/fincra_flutter.dart';

final fincra = Fincra(
  secretKey: 'sk_test_...',
  publicKey: 'pk_test_...',
  businessId: '63da...e200',
  environment: FincraEnvironment.sandbox, // default
);

// 1. List banks
final banks = await fincra.banks.list(currency: 'NGN');

// 2. Verify an account before paying out
final account = await fincra.verification.resolveAccount(
  accountNumber: '0690000040',
  bankCode: '044',
);
print('Paying ${account.accountName}');

// 3. Collect money via hosted checkout
final session = await fincra.checkout.initiate(
  CheckoutRequest(
    amount: 1500,
    currency: 'NGN',
    customer: const FincraCustomer(name: 'Ada Lovelace', email: 'ada@x.com'),
    redirectUrl: 'https://yourapp.com/return',
  ),
);
// open session.link in a WebView / browser

// 4. Send a payout
final payout = await fincra.payouts.initiate(
  PayoutRequest(
    amount: 900,
    sourceCurrency: 'NGN',
    destinationCurrency: 'NGN',
    customerReference: 'order_1001',
    beneficiary: Beneficiary(
      firstName: 'John', lastName: 'Doe',
      accountHolderName: account.accountName,
      accountNumber: '0690000040',
      bankCode: '044', type: 'individual', country: 'NG',
    ),
  ),
);
print(payout.status);
```

## Error handling

Every failed call throws a `FincraException` carrying `message`, `statusCode`,
`errorType` and any field-level `errors`:

```dart
try {
  await fincra.payouts.initiate(req);
} on FincraException catch (e) {
  print('${e.statusCode}: ${e.message}'); // e.g. 422: Insufficient balance
}
```

## ⚠️ Security: keep your secret key off the device

The **secret key** grants full access to your Fincra account. Anyone who
extracts it from a shipped app binary can move your money. For production:

- Keep only the **public key** on the device (it is safe to ship).
- Run payouts, balance checks and account resolution on **your own backend**,
  which holds the secret key, and have the app call your backend.
- Sandbox keys are fine to use directly while developing.

Treat the direct-from-app usage shown here and in `example/` as a sandbox
convenience, not a production architecture.

## Confirming payments

Do not trust the checkout browser redirect as proof of payment. Confirm the
final state with a **webhook** (recommended) or `fincra.checkout.verify(ref)`
/ `fincra.payouts.verify(ref)` against your backend.

## Example app

A runnable sample lives in [`example/`](example/) — it walks through banks →
account resolution → checkout → payout against the sandbox.

## License

MIT
