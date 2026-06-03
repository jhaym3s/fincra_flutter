/// A currency balance on your Fincra account.
class Wallet {
  const Wallet({
    required this.currency,
    required this.availableBalance,
    required this.totalBalance,
  });

  final String currency;
  final num availableBalance;
  final num totalBalance;

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      currency: (json['currency'] ?? '').toString(),
      availableBalance: (json['availableBalance'] ?? json['balance'] ?? 0) as num,
      totalBalance: (json['totalBalance'] ?? json['balance'] ?? 0) as num,
    );
  }

  @override
  String toString() => 'Wallet($currency: $availableBalance available)';
}
