# Fincra SDK — sample app

A small Flutter app that exercises every flow in `fincra_flutter` against the
**sandbox** environment.

## What it shows

| Screen            | SDK call                              | Endpoint                          |

 List banks         `fincra.banks.list()`                 | `GET /core/banks`                 |
 Resolve account    `fincra.verification.resolveAccount()`| `POST /core/accounts/resolve`     |
 Checkout           `fincra.checkout.initiate()`          | `POST /checkout/payments`         |
 Payout             `fincra.payouts.initiate()`           | `POST /disbursements/payouts`     |

The payout screen chains two calls — resolve the account to confirm the name,
then disburse — which mirrors a realistic flow.

## Run it

```bash
cd example
flutter pub get
flutter run
```

On the first screen, paste your **sandbox** credentials from the Fincra
dashboard (Settings → API keys):

- **Secret key** — required for all calls.
- **Public key** — required for checkout.
- **Business id** — required for payouts. (Fetchable via the business profile
  endpoint; entered manually here for simplicity.)

To actually complete a sandbox payout you must first fund your sandbox
balance — see Fincra's "Funding Test Balance" guide.

## Note

Typing a secret key into the UI is fine for a sandbox demo but not for
production. Ship only the public key in real apps and run privileged calls on
your backend. See the SDK [README](../README.md#-security-keep-your-secret-key-off-the-device).
