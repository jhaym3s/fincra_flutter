import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';

import 'banks_screen.dart';
import 'checkout_screen.dart';
import 'payout_screen.dart';
import 'resolve_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.fincra});

  final Fincra fincra;

  @override
  Widget build(BuildContext context) {
    final demos = <_Demo>[
      _Demo('List banks', Icons.account_balance,
          'GET /core/banks', (_) => BanksScreen(fincra: fincra)),
      _Demo('Resolve account', Icons.search,
          'POST /core/accounts/resolve', (_) => ResolveScreen(fincra: fincra)),
      _Demo('Checkout (collect)', Icons.shopping_cart_checkout,
          'POST /checkout/payments', (_) => CheckoutScreen(fincra: fincra)),
      _Demo('Payout (disburse)', Icons.send,
          'POST /disbursements/payouts', (_) => PayoutScreen(fincra: fincra)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Fincra SDK Demo')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final d = demos[i];
          return Card(
            child: ListTile(
              leading: Icon(d.icon),
              title: Text(d.title),
              subtitle: Text(d.endpoint,
                  style: const TextStyle(fontFamily: 'monospace')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: d.builder),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Demo {
  const _Demo(this.title, this.icon, this.endpoint, this.builder);
  final String title;
  final IconData icon;
  final String endpoint;
  final WidgetBuilder builder;
}
