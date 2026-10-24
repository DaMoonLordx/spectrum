import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../domain/entities/user_role.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _auth = Injector.authController;

  UserRole _role = UserRole.cliente;
  bool _acceptedTerms = false;
  bool _termsError = false;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final formOk = _formKey.currentState!.validate();
    setState(() => _termsError = !_acceptedTerms);
    if (!formOk || !_acceptedTerms) return;

    final ok = await _auth.signUp(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      role: _role,
    );
    if (!mounted) return;

    if (ok) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_auth.error ?? 'No se pudo crear la cuenta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crea tu cuenta',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        Validators.requiredField(v, field: 'El nombre'),
                    decoration:
                        const InputDecoration(labelText: 'Nombre completo'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.email,
                    decoration:
                        const InputDecoration(labelText: 'Correo electrónico'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.password,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      helperText: 'Mínimo 8 caracteres y un número',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        Validators.confirmPassword(v, _passwordCtrl.text),
                    decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña'),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Selecciona tu rol',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final role in UserRole.values)
                        ChoiceChip(
                          label: Text(role.label),
                          selected: _role == role,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.field,
                          side: BorderSide.none,
                          showCheckmark: false,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (_) => setState(() => _role = role),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _role.description,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primary,
                    value: _acceptedTerms,
                    onChanged: (v) => setState(() {
                      _acceptedTerms = v ?? false;
                      _termsError = false;
                    }),
                    title: const Text(
                        'Acepto los términos y la política de privacidad'),
                    subtitle: _termsError
                        ? const Text(
                            'Debes aceptar para continuar',
                            style: TextStyle(color: AppColors.pink),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _auth,
                    builder: (_, __) => GradientButton(
                      label: 'Crear cuenta',
                      isLoading: _auth.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
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
}
