/// A bank or mobile money operator returned by the List Banks endpoint.
///
/// [code] is the value passed as `bankCode` (or `mobileMoneyCode`) when making
/// a payout. When [isMobileVerified] is true the entry is a mobile money
/// operator rather than a traditional bank.
class Bank {
  const Bank({
    required this.id,
    required this.code,
    required this.name,
    this.isMobileVerified = false,
    this.swiftCode,
  });

  final String id;
  final String code;
  final String name;
  final bool isMobileVerified;
  final String? swiftCode;

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      isMobileVerified: json['isMobileVerified'] == true,
      swiftCode: json['swiftCode']?.toString(),
    );
  }

  @override
  String toString() => 'Bank($name, code: $code)';
}
