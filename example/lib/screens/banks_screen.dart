import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';

/// Demonstrates `fincra.banks.list()`.
class BanksScreen extends StatefulWidget {
  const BanksScreen({super.key, required this.fincra});
  final Fincra fincra;

  @override
  State<BanksScreen> createState() => _BanksScreenState();
}

class _BanksScreenState extends State<BanksScreen> {
  late Future<List<Bank>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.fincra.banks.list(currency: 'NGN', country: 'NG');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banks')),
      body: FutureBuilder<List<Bank>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _ErrorView(error: snap.error!);
          }
          final banks = snap.data!;
          return ListView.builder(
            itemCount: banks.length,
            itemBuilder: (_, i) => ListTile(
              dense: true,
              leading: Icon(banks[i].isMobileVerified
                  ? Icons.phone_android
                  : Icons.account_balance),
              title: Text(banks[i].name),
              trailing: Text(banks[i].code),
            ),
          );
        },
      ),
    );
  }
}

/// Shared widget for rendering a [FincraException] (or any error) nicely.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    final message =
        error is FincraException ? (error as FincraException).message : '$error';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
