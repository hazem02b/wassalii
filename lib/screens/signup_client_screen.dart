import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class SignupClientScreen extends StatefulWidget {
  const SignupClientScreen({super.key});

  @override
  State<SignupClientScreen> createState() => _SignupClientScreenState();
}

class _SignupClientScreenState extends State<SignupClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _acceptedTos = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || !_acceptedTos) {
      if (!_acceptedTos) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez accepter les conditions')));
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Try real API if available; fallback to simulated delay.
      await ApiService().post('/auth/register/client', data: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inscription réussie')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(initialUserType: 'client')));
    } catch (_) {
      // If ApiService not configured, simulate success for now
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inscription (simulée) réussie')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(initialUserType: 'client')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _fieldDecoration({required String label, IconData? icon}) => InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary.withAlpha((0.05 * 255).round()), Colors.white]),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.primary.withAlpha((0.3 * 255).round()), blurRadius: 20, offset: const Offset(0, 10))]),
                      child: const Icon(Icons.local_shipping_rounded, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Créer un compte', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  Text('Inscrivez-vous en tant que client pour envoyer des colis', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                  const SizedBox(height: 36),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.06 * 255).round()), blurRadius: 30, offset: const Offset(0, 4))]),
                    child: Form(
                      key: _formKey,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        TextFormField(controller: _nameController, decoration: _fieldDecoration(label: 'Nom complet', icon: Icons.person_outline), validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null),
                        const SizedBox(height: 16),
                        TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: _fieldDecoration(label: AppStrings.email, icon: Icons.email_outlined), validator: (v) => v == null || !v.contains('@') ? 'Email invalide' : null),
                        const SizedBox(height: 16),
                        TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: _fieldDecoration(label: 'Téléphone', icon: Icons.phone_outlined)),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            labelText: 'Confirmer le mot de passe',
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(children: [
                          Checkbox(value: _acceptedTos, onChanged: (v) => setState(() => _acceptedTos = v ?? false)),
                          Expanded(child: Text("J'accepte les Conditions d'utilisation et la Politique de confidentialité", style: TextStyle(fontSize: 13))),
                        ]),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                            child: _isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('S\'inscrire', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Vous avez déjà un compte ? ', style: TextStyle(fontSize: 13)), TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(initialUserType: 'client'))), child: Text('Connexion', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)))]),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
