import 'package:coachpulse/core/providers.dart';
import 'package:coachpulse/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final loc = stringsOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.appTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _email,
                  decoration: InputDecoration(labelText: loc.email),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: loc.password),
                ),
                const SizedBox(height: 16),
                if (_error != null)
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                FilledButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() {
                            _loading = true;
                            _error = null;
                          });
                          try {
                            await ref.read(authRepositoryProvider).signIn(
                                  email: _email.text.trim(),
                                  password: _password.text,
                                );
                            if (mounted) context.go('/today');
                          } catch (_) {
                            setState(() => _error = 'Login failed');
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                  child: Text(loc.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
