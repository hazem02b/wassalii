import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withAlpha((0.8 * 255).round()),
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo avec animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((0.2 * 255).round()),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            size: 70,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Titre principal
                  const Text(
                    'Wassali',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Slogan
                  Text(
                    'Livraison de colis rapide et sécurisée',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withAlpha((0.9 * 255).round()),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Benefits grid (match web)
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _SmallBenefit(icon: Icons.flash_on_outlined, label: 'Rapide'),
                      _SmallBenefit(icon: Icons.attach_money_outlined, label: 'Abordable'),
                      _SmallBenefit(icon: Icons.shield_outlined, label: 'Fiable'),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Large action buttons (match web design)
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signup-client'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              elevation: 8,
                              shadowColor: Colors.black.withAlpha((0.15 * 255).round()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha((0.08 * 255).round()),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.local_shipping_outlined, color: AppColors.primary),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Continuer en tant que client', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                      SizedBox(height: 4),
                                      Text('Envoyer des colis facilement', style: TextStyle(fontSize: 13, color: Colors.black54)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signup-transporter'),
                            style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.transporter,
                                  foregroundColor: Colors.white,
                                  elevation: 8,
                                  shadowColor: Colors.black.withAlpha((0.12 * 255).round()),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: AppColors.transporterDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.local_shipping, color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Devenir transporteur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                                      const SizedBox(height: 4),
                                      Text("Gagner de l'argent en livrant", style: TextStyle(fontSize: 13, color: AppColors.transporter.withAlpha((0.18 * 255).round()))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // Connexion link
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Vous avez déjà un compte ? Connexion",
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.95 * 255).round()),
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Removed unused _FeatureCard to clean analyzer warnings.

class _SmallBenefit extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SmallBenefit({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.08 * 255).round()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
