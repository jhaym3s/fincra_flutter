import 'package:meta/meta.dart';

import 'fincra_environment.dart';


@immutable
class FincraConfig {
  const FincraConfig({
    required this.secretKey,
    this.publicKey,
    this.businessId,
    this.environment = FincraEnvironment.sandbox,
    this.timeout = const Duration(seconds: 30),
  });

  final String secretKey;

  final String? publicKey;

  final String? businessId;

  /// environment to target. Defaults to [FincraEnvironment.sandbox].
  final FincraEnvironment environment;

  /// Per-request network timeout.
  final Duration timeout;

  /// Base URL derived from [environment].
  /// provide from remote config
  String get baseUrl => environment.baseUrl;

  FincraConfig copyWith({
    String? secretKey,
    String? publicKey,
    String? businessId,
    FincraEnvironment? environment,
    Duration? timeout,
  }) {
    return FincraConfig(
      secretKey: secretKey ?? this.secretKey,
      publicKey: publicKey ?? this.publicKey,
      businessId: businessId ?? this.businessId,
      environment: environment ?? this.environment,
      timeout: timeout ?? this.timeout,
    );
  }
}
