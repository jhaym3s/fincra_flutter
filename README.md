# fincra_flutter

An unofficial Flutter/Dart SDK for the *Fincra* payment
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
    git: https://github.com/jhaym3s/fincra_flutter.git
```

## Quick start

```dart
import 'package:fincra_flutter/fincra_flutter.dart';

final fincra = Fincra(
  secretKey: 'string'
  publicKey: 'string',
  businessId: 'string',
  environment: FincraEnvironment.sandbox, 
);

// 1. List banks
final banks = await fincra.banks.list(currency: 'NGN');

// 2. Verify an account before paying out
final account = await fincra.verification.resolveAccount(
  accountNumber: 'string',
  bankCode: 'string',
);
print('Paying ${account.accountName}');

// 3. Collect money via hosted checkout
final session = await fincra.checkout.initiate(
  CheckoutRequest(
    amount: 1500,
    currency: 'NGN',
    customer: const FincraCustomer(name: 'James Ifiok', email: 'james.com'),
    redirectUrl: 'https://travoli.co/',
  ),
);

// 4. Send a payout
final payout = await fincra.payouts.initiate(
  PayoutRequest(
    amount: 900,
    sourceCurrency: 'NGN',
    destinationCurrency: 'NGN',
    customerReference: 'order_1',
    beneficiary: Beneficiary(
      firstName: 'John', lastName: 'Doe',
      accountHolderName: account.accountName,
      accountNumber: '0105150878',
      bankCode: '044', type: 'individual', country: 'NG',
    ),
  ),
);
print(payout.status);
```



##  Security: keep your secret key off the device

The *secret key* grants full access to your Fincra account. Anyone who
extracts it from a shipped app binary can move your money. 

## For production:

- Keep only the *public key* on the device (it is safe to ship).
- Run payouts, balance checks and account resolution on *your own backend*,
  which holds the secret key, and have the app call your backend.
- Sandbox keys are fine to use directly while developing.

Treat the direct-from-app usage shown here and in `example/` as a sandbox
convenience, not a production architecture.

## License

MIT
