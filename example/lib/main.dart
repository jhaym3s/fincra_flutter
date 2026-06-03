import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const FincraDemoApp());

class FincraDemoApp extends StatelessWidget {
  const FincraDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fincra SDK Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1A56DB),
        useMaterial3: true,
      ),
      home: const SetupScreen(),
    );
  }
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _secret = TextEditingController();
  final _public = TextEditingController();
  final _business = TextEditingController();

  @override
  void dispose() {
    _secret.dispose();
    _public.dispose();
    _business.dispose();
    super.dispose();
  }

  void _start() {
    if (_secret.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A sandbox secret key is required.')),
      );
      return;
    }
    final fincra = Fincra(
      secretKey: _secret.text.trim(),
      publicKey: _public.text.trim().isEmpty ? null : _public.text.trim(),
      businessId:
          _business.text.trim().isEmpty ? null : _business.text.trim(),
      environment: FincraEnvironment.sandbox,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => HomeScreen(fincra: fincra)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fincra SDK Demo')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Enter your Fincra SANDBOX credentials to try the SDK.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _secret,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Secret key (api-key)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _public,
            decoration: const InputDecoration(
              labelText: 'Public key (x-pub-key)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _business,
            decoration: const InputDecoration(
              labelText: 'Business id — needed for payouts',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _start, child: const Text('Continue')),
        
        ],
      ),
    );
  }
}
