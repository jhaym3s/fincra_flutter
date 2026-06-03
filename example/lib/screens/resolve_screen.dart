import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';

/// Demonstrates `fincra.verification.resolveAccount()`.
///
/// Lets you pick a bank (loaded from the SDK) and enter an account number,
/// then shows the resolved account name.
class ResolveScreen extends StatefulWidget {
  const ResolveScreen({super.key, required this.fincra});
  final Fincra fincra;

  @override
  State<ResolveScreen> createState() => _ResolveScreenState();
}

class _ResolveScreenState extends State<ResolveScreen> {
  final _accountNumber = TextEditingController(text: '0690000040');
  List<Bank> _banks = const [];
  Bank? _selected;
  ResolvedAccount? _result;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    widget.fincra.banks
        .list(currency: 'NGN')
        .then((b) => setState(() {
              _banks = b;
              if (b.isNotEmpty) _selected = b.first;
            }))
        .catchError((Object e) => setState(() => _error = '$e'));
  }

  @override
  void dispose() {
    _accountNumber.dispose();
    super.dispose();
  }

  Future<void> _resolve() async {
    if (_selected == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final acct = await widget.fincra.verification.resolveAccount(
        accountNumber: _accountNumber.text.trim(),
        bankCode: _selected!.code,
      );
      setState(() => _result = acct);
    } on FincraException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resolve account')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<Bank>(
            value: _selected,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Bank',
              border: OutlineInputBorder(),
            ),
            items: _banks
                .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                .toList(),
            onChanged: (b) => setState(() => _selected = b),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _accountNumber,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Account number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _resolve,
            child: _loading
                ? const SizedBox(
                    height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Resolve'),
          ),
          const SizedBox(height: 20),
          if (_result != null)
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(_result!.accountName),
                subtitle: Text(_result!.accountNumber),
              ),
            ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
