import '../core/fincra_http_client.dart';

/// Shared base for all resource services. Holds the [FincraHttpClient] that
/// the concrete services use to talk to the API.
abstract class BaseService {
  const BaseService(this.client);

  final FincraHttpClient client;
}
