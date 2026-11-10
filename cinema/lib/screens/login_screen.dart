import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isLogin = true, _hide = true;

  @override
  void dispose() { _name.dispose(); _email.dispose(); _pass.dispose(); super.dispose(); }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<AppState>().login(_name.text.trim(), _email.text.trim());
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF200122), Color(0xFF6F0000)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (_, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(offset: Offset(0, 30 * (1 - v)), child: child)),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _form,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.local_movies, size: 56, color: kBrand),
                        const Text('CINEMA',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 6)),
                        const SizedBox(height: 4),
                        Text(_isLogin ? 'Welcome back' : 'Create your account'),
                        const SizedBox(height: 20),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isLogin
                              ? const SizedBox(width: double.infinity)
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: TextFormField(
                                    controller: _name,
                                    decoration: const InputDecoration(
                                        labelText: 'Full name', prefixIcon: Icon(Icons.person)),
                                    validator: (v) => (v == null || v.trim().length < 3)
                                        ? 'Name must be at least 3 characters' : null,
                                  ),
                                ),
                        ),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email', prefixIcon: Icon(Icons.email)),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email is required';
                            return RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(v.trim())
                                ? null : 'Enter a valid email';
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _pass,
                          obscureText: _hide,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _hide = !_hide),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Password must be at least 6 characters' : null,
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: _submit,
                              child: Text(_isLogin ? 'Sign In' : 'Sign Up')),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(_isLogin
                              ? "New here? Create an account"
                              : 'Already have an account? Sign in'),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
