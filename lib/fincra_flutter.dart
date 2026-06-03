/// An unofficial Flutter/Dart SDK for the Fincra payment API.
///
/// Import this single file to access everything:
/// ```dart
/// import 'package:fincra_flutter/fincra_flutter.dart';
/// ```
library fincra_flutter;

export 'src/fincra.dart';

// Core
export 'src/core/fincra_config.dart';
export 'src/core/fincra_environment.dart';
export 'src/core/fincra_exception.dart';
export 'src/core/api_response.dart';

// Models
export 'src/models/bank.dart';
export 'src/models/resolved_account.dart';
export 'src/models/checkout.dart';
export 'src/models/payout.dart';
export 'src/models/wallet.dart';
export 'src/models/business.dart';

// Services (exported for typing; reach them via the Fincra client)
export 'src/services/banks_service.dart';
export 'src/services/verification_service.dart';
export 'src/services/checkout_service.dart';
export 'src/services/payouts_service.dart';
export 'src/services/wallets_service.dart';
