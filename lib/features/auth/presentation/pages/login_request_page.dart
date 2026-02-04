import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/app_state.dart';
import '../viewmodels/auth_view_model.dart';

class LoginRequestPage extends StatefulWidget {
  const LoginRequestPage({
    super.key,
    required this.authViewModel,
    required this.appState,
  });

  final AuthViewModel authViewModel;
  final AppState appState;

  @override
  State<LoginRequestPage> createState() => _LoginRequestPageState();
}

class _LoginRequestPageState extends State<LoginRequestPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.appState.loginEmail ?? '');
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Entrer votre email pour recevoir un code.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v != null && v.contains('@') ? null : 'Email invalide',
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: widget.authViewModel,
                    builder: (_, _) => Column(
                      children: [
                        if (widget.authViewModel.error != null)
                          Text(
                            widget.authViewModel.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.authViewModel.isLoading
                                ? null
                                : _submit,
                            child: widget.authViewModel.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Recevoir le code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await widget.authViewModel.requestLogin(_emailCtrl.text);
    if (mounted && success) {
      context.go('/verify');
    }
  }
}
