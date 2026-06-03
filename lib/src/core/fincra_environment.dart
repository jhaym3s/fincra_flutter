/// The Fincra environment the SDK talks to.
///
/// Fincra exposes two completely isolated environments. Sandbox uses
/// simulated data and never moves real money; live processes real,
/// irreversible transactions. API keys, business IDs and webhooks created
/// in one environment do **not** carry over to the other.
enum FincraEnvironment {
  /// Test environment. Base URL: https://sandboxapi.fincra.com
  sandbox('https://sandboxapi.fincra.com'),

  /// Production environment. Base URL: https://api.fincra.com
  live('https://api.fincra.com');

  const FincraEnvironment(this.baseUrl);

  /// The root URL for this environment, without a trailing slash.
  final String baseUrl;
}
