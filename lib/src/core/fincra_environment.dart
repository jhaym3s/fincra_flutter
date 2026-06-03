
enum FincraEnvironment {
  /// Test environment. 
  sandbox('https://sandboxapi.fincra.com'),

  /// Production environment.
  live('https://api.fincra.com');

  const FincraEnvironment(this.baseUrl);

  /// The root URL for this environment, without a trailing slash.
  final String baseUrl;
}
