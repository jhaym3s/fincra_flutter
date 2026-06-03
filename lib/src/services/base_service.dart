import '../core/fincra_http_client.dart';

abstract class BaseService {
  const BaseService(this.client);

  final FincraHttpClient client;
}
