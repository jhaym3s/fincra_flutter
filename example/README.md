# Fincra SDK — sample app

A small Flutter app that exercises every flow in `fincra_flutter` against the
*sandbox* environment.

## What it shows

 Screen             SDK call                              Endpoint                          

 List banks         `fincra.banks.list()`                  `GET /core/banks`                 
 Resolve account    `fincra.verification.resolveAccount()` `POST /core/accounts/resolve`     
 Checkout           `fincra.checkout.initiate()`           `POST /checkout/payments`         
 Payout             `fincra.payouts.initiate()`            `POST /disbursements/payouts`     

The payout screen chains two calls — resolve the account to confirm the name,
then disburse — which mirrors a realistic flow.

## Run it

```bash
cd example
flutter run
```

On the first screen, paste your **sandbox** credentials from the Fincra
dashboard (Settings → API keys):

- **Secret key** — required for all calls.
- **Public key** — required for checkout.
- **Business id** — required for payouts. (Fetchable via the business profile
  endpoint; entered manually here for simplicity.)


