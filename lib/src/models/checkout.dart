/// The customer being charged in a checkout.
class FincraCustomer {
  const FincraCustomer({
    required this.name,
    required this.email,
    this.phoneNumber,
  });

  /// Full name in "Firstname Lastname" format, e.g. "Ada Lovelace".
  final String name;
  final String email;
  final String? phoneNumber;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };
}

/// Request payload for initiating a hosted checkout (`POST /checkout/payments`).
class CheckoutRequest {
  const CheckoutRequest({
    required this.amount,
    required this.currency,
    required this.customer,
    this.reference,
    this.paymentMethods = const ['card', 'bank_transfer'],
    this.feeBearer = 'business',
    this.redirectUrl,
    this.defaultPaymentMethod,
    this.metadata,
  });

  final num amount;

  /// One of NGN, KES, GHS, UGX, USD, ZMW, XAF, XOF, TZS.
  final String currency;
  final FincraCustomer customer;

  /// Your unique reference. If omitted, Fincra generates one.
  final String? reference;

  /// e.g. ['card', 'bank_transfer', 'payAttitude'].
  final List<String> paymentMethods;

  /// Who pays the fee: 'business' or 'customer'.
  final String feeBearer;
  final String? redirectUrl;
  final String? defaultPaymentMethod;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'customer': customer.toJson(),
        'paymentMethods': paymentMethods,
        'feeBearer': feeBearer,
        if (reference != null) 'reference': reference,
        if (redirectUrl != null) 'redirectUrl': redirectUrl,
        if (defaultPaymentMethod != null)
          'defaultPaymentMethod': defaultPaymentMethod,
        if (metadata != null) 'metadata': metadata,
      };
}

/// The hosted checkout link returned by Fincra.
///
/// Open [link] in a WebView or external browser; the customer completes
/// payment there and is sent to your `redirectUrl`. Confirm the final state
/// server-side via webhook or the verify endpoint — never trust the redirect
/// alone.
class CheckoutSession {
  const CheckoutSession({
    required this.link,
    required this.reference,
    this.payCode,
  });

  final String link;
  final String reference;
  final String? payCode;

  factory CheckoutSession.fromJson(Map<String, dynamic> json) {
    return CheckoutSession(
      link: (json['link'] ?? '').toString(),
      reference: (json['reference'] ?? '').toString(),
      payCode: json['payCode']?.toString(),
    );
  }

  @override
  String toString() => 'CheckoutSession(reference: $reference, link: $link)';
}
