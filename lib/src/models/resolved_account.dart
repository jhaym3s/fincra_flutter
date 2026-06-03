/// The result of verifying a bank account via `/core/accounts/resolve`.
class ResolvedAccount {
  const ResolvedAccount({
    required this.accountNumber,
    required this.accountName,
  });

  final String accountNumber;
  final String accountName;

  factory ResolvedAccount.fromJson(Map<String, dynamic> json) {
    return ResolvedAccount(
      accountNumber: (json['accountNumber'] ?? '').toString(),
      accountName: (json['accountName'] ?? '').toString(),
    );
  }

  @override
  String toString() => 'ResolvedAccount($accountName / $accountNumber)';
}
