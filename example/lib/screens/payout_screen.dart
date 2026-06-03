import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';

/// Demonstrates `fincra.payouts.initiate()`.
///
/// Mirrors a real flow: pick a bank, resolve the account to confirm the name,
/// then disburse. Requires a business id configured on the client (or set in
/// the request) and a funded sandbox balance.
class PayoutScreen extends StatefulWidget {
  const PayoutScreen({super.key, required this.fincra});
  final Fincra fincra;

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final _amount = TextEditingController(text: '900');
  final _accountNumber = TextEditingController(text: '0690000040');
  List<Bank> _banks = const [];
  Bank? _bank;
  ResolvedAccount? _resolved;
  Payout? _payout;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    widget.fincra.banks.list(currency: 'NGN').then(
        (b) => setState(() {
              _banks = b;
              if (b.isNotEmpty) _bank = b.first;
            }),
        onError: (Object e) => setState(() => _error = '$e'));
  }

  @override
  void dispose() {
    _amount.dispose();
    _accountNumber.dispose();
    super.dispose();
  }

  Future<void> _resolve() async {
    if (_bank == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      _resolved = await widget.fincra.verification.resolveAccount(
        accountNumber: _accountNumber.text.trim(),
        bankCode: _bank!.code,
      );
    } on FincraException catch (e) {
      _error = e.message;
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _pay() async {
    if (_resolved == null || _bank == null) return;
    setState(() {
      _busy = true;
      _error = null;
      _payout = null;
    });
    final names = _resolved!.accountName.split(' ');
    try {
      final payout = await widget.fincra.payouts.initiate(
        PayoutRequest(
          amount: num.tryParse(_amount.text.trim()) ?? 0,
          sourceCurrency: 'NGN',
          destinationCurrency: 'NGN',
          description: 'Demo payout',
          customerReference: 'demo_${DateTime.now().millisecondsSinceEpoch}',
          beneficiary: Beneficiary(
            firstName: names.first,
            lastName: names.length > 1 ? names.last : names.first,
            accountHolderName: _resolved!.accountName,
            accountNumber: _accountNumber.text.trim(),
            bankCode: _bank!.code,
            type: 'individual',
            country: 'NG',
          ),
        ),
      );
      setState(() => _payout = payout);
    } on FincraException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payout')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<Bank>(
            value: _bank,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Bank', border: OutlineInputBorder()),
            items: _banks
                .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                .toList(),
            onChanged: (b) => setState(() {
              _bank = b;
              _resolved = null;
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _accountNumber,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Account number', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (NGN)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _busy ? null : _resolve,
            child: const Text('1. Resolve account'),
          ),
          if (_resolved != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Recipient: ${_resolved!.accountName}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: (_busy || _resolved == null) ? null : _pay,
            child: _busy
                ? const SizedBox(
                    height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('2. Send payout'),
          ),
          const SizedBox(height: 20),
          if (_payout != null)
            Card(
              color: _payout!.isFailed
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              child: ListTile(
                leading: Icon(
                  _payout!.isFailed ? Icons.error : Icons.check_circle,
                  color: _payout!.isFailed ? Colors.red : Colors.green,
                ),
                title: Text('Status: ${_payout!.status}'),
                subtitle: Text('Ref: ${_payout!.reference}'),
              ),
            ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
