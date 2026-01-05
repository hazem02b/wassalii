import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../models/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserType _selectedUserType = UserType.client;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userType: _selectedUserType,
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      if (!mounted) return;

      if (success && authProvider.currentUser != null) {
        final user = authProvider.currentUser!;
        final nextRoute = user.userType == UserType.client
            ? '/home-client'
            : '/transporter-dashboard';
        Navigator.pushReplacementNamed(context, nextRoute);
      } else {
        setState(() {
          _errorMessage = authProvider.error ?? 'Erreur d\'inscription';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withAlpha((0.05 * 255).round()),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha((0.3 * 255).round()),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_shipping_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 28),
                    
                    // Titre
                    const Text(
                      'Créer un compte',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    Text(
                      'Rejoignez-nous dès maintenant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    
                    const SizedBox(height: 36),
                    
                    // Card Formulaire
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.06 * 255).round()),
                            blurRadius: 30,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Erreur
                            if (_errorMessage != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.error.withAlpha((0.3 * 255).round()),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: AppColors.error, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Type utilisateur
                            const Text(
                              'Type de compte',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedUserType = UserType.client),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          gradient: _selectedUserType == UserType.client
                                              ? AppColors.primaryGradient
                                              : null,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: _selectedUserType == UserType.client
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.primary.withAlpha((0.3 * 255).round()),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Client',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: _selectedUserType == UserType.client
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedUserType = UserType.transporter),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          gradient: _selectedUserType == UserType.transporter
                                              ? const LinearGradient(
                                                  colors: [Color(0xFFFF9500), Color(0xFFFF7A00)],
                                                )
                                              : null,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: _selectedUserType == UserType.transporter
                                              ? [
                                                  BoxShadow(
                                                    color: const Color(0xFFFF9500).withAlpha((0.3 * 255).round()),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Transporteur',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: _selectedUserType == UserType.transporter
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Prénom et Nom
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    style: const TextStyle(fontSize: 15),
                                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                                    decoration: const InputDecoration(
                                      labelText: 'Prénom',
                                      filled: true,
                                      fillColor: AppColors.backgroundLight,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    style: const TextStyle(fontSize: 15),
                                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                                    decoration: const InputDecoration(
                                      labelText: 'Nom',
                                      filled: true,
                                      fillColor: AppColors.backgroundLight,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 18),
                            
                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 15),
                              validator: (v) => v == null || !v.contains('@') ? 'Email invalide' : null,
                              decoration: const InputDecoration(
                                labelText: 'Adresse email',
                                prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 20),
                                filled: true,
                                fillColor: AppColors.backgroundLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 18),
                            
                            // Téléphone
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(fontSize: 15),
                              decoration: const InputDecoration(
                                labelText: 'Téléphone (optionnel)',
                                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                                filled: true,
                                fillColor: AppColors.backgroundLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 18),
                            
                            // Mot de passe
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(fontSize: 15),
                              validator: (v) => v == null || v.length < 6 ? 'Min 6 caractères' : null,
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
                                filled: true,
                                fillColor: AppColors.backgroundLight,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 18),
                            
                            // Confirmer mot de passe
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(fontSize: 15),
                              validator: (v) => v != _passwordController.text ? 'Non identique' : null,
                              decoration: InputDecoration(
                                labelText: 'Confirmer mot de passe',
                                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
                                filled: true,
                                fillColor: AppColors.backgroundLight,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 28),
                            
                            // Bouton
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedUserType == UserType.client ? AppColors.primary : AppColors.transporter,
                                      disabledBackgroundColor: (_selectedUserType == UserType.client ? AppColors.primary : AppColors.transporter).withAlpha((0.6 * 255).round()),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Créer mon compte',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Lien connexion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Déjà un compte ? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
