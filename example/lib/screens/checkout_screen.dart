import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.fincra});
  final Fincra fincra;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _amount = TextEditingController(text: '1500');
  final _name = TextEditingController(text: 'James Ifiok');
  final _email = TextEditingController(text: 'chizoba@example.com');
  CheckoutSession? _session;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _amount.dispose();
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _createCheckout() async {
    setState(() {
      _loading = true;
      _error = null;
      _session = null;
    });
    try {
      final session = await widget.fincra.checkout.initiate(
        CheckoutRequest(
          amount: num.tryParse(_amount.text.trim()) ?? 0,
          currency: 'NGN',
          customer: FincraCustomer(
            name: _name.text.trim(),
            email: _email.text.trim(),
          ),
          paymentMethods: const ['card', 'bank_transfer'],
          redirectUrl: 'https://example.com/return',
        ),
      );
      setState(() => _session = session);
    } on FincraException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openLink() async {
    final uri = Uri.parse(_session!.link);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      setState(() => _error = 'Could not open checkout link.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (NGN)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Customer name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Customer email', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _createCheckout,
            child: _loading
                ? const SizedBox(
                    height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Create checkout link'),
          ),
          const SizedBox(height: 20),
          if (_session != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reference: ${_session!.reference}'),
                    const SizedBox(height: 8),
                    SelectableText(_session!.link,
                        style: const TextStyle(color: Colors.blue)),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: _openLink,
                      child: const Text('Open checkout'),
                    ),
                  ],
                ),
              ),
            ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
