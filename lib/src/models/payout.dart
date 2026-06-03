/// The recipient of a payout.
///
/// Required fields vary by destination currency and payment destination; the
/// set below covers same-currency NGN bank transfers. For cross-currency or
/// mobile money payouts you may also need `sortCode`, `bankSwiftCode`,
/// `mobileMoneyCode`, address, etc.
class Beneficiary {
  const Beneficiary({
    required this.firstName,
    required this.lastName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.type,
    required this.country,
    this.bankCode,
    this.email,
    this.phone,
    this.mobileMoneyCode,
  });

  final String firstName;
  final String lastName;
  final String accountHolderName;
  final String accountNumber;

  /// 'individual' or 'corporate'.
  final String type;

  /// ISO country code, e.g. 'NG'.
  final String country;

  /// Bank code from the List Banks endpoint (for bank transfers).
  final String? bankCode;
  final String? email;
  final String? phone;

  /// Mobile money operator code (for mobile money payouts).
  final String? mobileMoneyCode;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'accountHolderName': accountHolderName,
        'accountNumber': accountNumber,
        'type': type,
        'country': country,
        if (bankCode != null) 'bankCode': bankCode,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (mobileMoneyCode != null) 'mobileMoneyCode': mobileMoneyCode,
      };
}

/// Request payload for `POST /disbursements/payouts`.
class PayoutRequest {
  const PayoutRequest({
    required this.amount,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.beneficiary,
    required this.customerReference,
    this.business,
    this.description,
    this.paymentDestination = 'bank_account',
    this.sender,
  });

  final num amount;
  final String sourceCurrency;
  final String destinationCurrency;
  final Beneficiary beneficiary;

  /// Your unique idempotent reference for this payout.
  final String customerReference;

  /// Parent business id. Falls back to the client's configured business id.
  final String? business;
  final String? description;

  /// 'bank_account' or 'mobile_money'.
  final String paymentDestination;
  final Map<String, dynamic>? sender;

  Map<String, dynamic> toJson() => {
        'amount': amount.toString(),
        'sourceCurrency': sourceCurrency,
        'destinationCurrency': destinationCurrency,
        'customerReference': customerReference,
        'paymentDestination': paymentDestination,
        'beneficiary': beneficiary.toJson(),
        if (business != null) 'business': business,
        if (description != null) 'description': description,
        if (sender != null) 'sender': sender,
      };
}

/// A payout record as returned when initiating or verifying a payout.
class Payout {
  const Payout({
    required this.reference,
    required this.status,
    this.id,
    this.amountSent,
    this.amountReceived,
    this.sourceCurrency,
    this.destinationCurrency,
    this.customerReference,
    this.message,
  });

  final String reference;

  /// e.g. 'pending', 'processing', 'successful', 'failed'.
  final String status;
  final int? id;
  final num? amountSent;
  final num? amountReceived;
  final String? sourceCurrency;
  final String? destinationCurrency;
  final String? customerReference;
  final String? message;

  bool get isSuccessful => status.toLowerCase() == 'successful';
  bool get isFailed => status.toLowerCase() == 'failed';

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      reference: (json['reference'] ?? '').toString(),
      status: (json['status'] ?? 'unknown').toString(),
      id: json['id'] is int ? json['id'] as int : null,
      amountSent: json['amountSent'] as num?,
      amountReceived: json['amountReceived'] as num?,
      sourceCurrency: json['sourceCurrency']?.toString(),
      destinationCurrency: json['destinationCurrency']?.toString(),
      customerReference: json['customerReference']?.toString(),
      message: json['message']?.toString(),
    );
  }

  @override
  String toString() => 'Payout(reference: $reference, status: $status)';
}
