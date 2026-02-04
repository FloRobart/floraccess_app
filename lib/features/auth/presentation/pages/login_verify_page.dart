import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/app_state.dart';
import '../viewmodels/auth_view_model.dart';

class LoginVerifyPage extends StatefulWidget {
  const LoginVerifyPage({
    super.key,
    required this.authViewModel,
    required this.appState,
  });

  final AuthViewModel authViewModel;
  final AppState appState;

  @override
  State<LoginVerifyPage> createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.appState.loginEmail ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
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
                  Text('Un code a été envoyé à $email'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeCtrl,
                    decoration: const InputDecoration(labelText: 'Code'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v != null && v.length >= 4 ? null : 'Code invalide',
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
                                : const Text('Valider'),
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
    final success = await widget.authViewModel.confirmLogin(_codeCtrl.text);
    if (mounted && success) {
      context.go('/');
    }
  }
}
