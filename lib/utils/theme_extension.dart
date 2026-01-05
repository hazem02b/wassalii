import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  // Récupérer le thème actuel
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  // Vérifier si c'est le mode sombre
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  // Couleurs adaptatives
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB);
  Color get surfaceColor => isDarkMode ? const Color(0xFF374151) : Colors.white;
  Color get cardColor => isDarkMode ? const Color(0xFF374151) : Colors.white;
  
  // Couleurs de texte adaptatives
  Color get textPrimary => isDarkMode ? Colors.white : const Color(0xFF111827);
  Color get textSecondary => isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280);
  Color get textTertiary => isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF);
  
  // Couleurs de bordure adaptatives
  Color get borderColor => isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB);
  
  // Couleurs de fond adaptatives
  Color get inputBackground => isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6);
  Color get hoverBackground => isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFF3F4F6);
  
  // Couleurs d'accent adaptatives
  Color get accentBlue => const Color(0xFF0066FF);
  Color get accentBlueLight => isDarkMode ? const Color(0xFF1E40AF) : const Color(0xFFEFF6FF);
  
  // Couleurs de statut
  Color get successColor => const Color(0xFF10B981);
  Color get warningColor => const Color(0xFFF59E0B);
  Color get errorColor => const Color(0xFFEF4444);
  Color get infoColor => const Color(0xFF3B82F6);
}
