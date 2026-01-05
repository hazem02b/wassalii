import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - IDENTIQUES AU WEB
  static const Color primary = Color(0xFF0066FF); // Bleu web exact
  static const Color primaryDark = Color(0xFF0052CC); // Gradient web
  static const Color secondary = Color(0xFFF3F3F5); // Gris secondaire web
  static const Color accent = Color(0xFFE9EBEF); // Accent web
  
  // Background Colors - IDENTIQUES AU WEB
  static const Color background = Color(0xFFF9FAFB); // bg-gray-50
  static const Color backgroundLight = Color(0xFFF5F5F5); // bg-gray-100
  static const Color backgroundDark = Color(0xFF000000); // Noir pour mode sombre
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E); // Gris très foncé pour cartes
  
  // Text Colors - IDENTIQUES AU WEB
  static const Color textPrimary = Color(0xFF030213); // Noir web
  static const Color textSecondary = Color(0xFF717182); // Gris muted web
  static const Color textLight = Color(0xFF9CA3AF); // gray-400
  static const Color textWhite = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // green-500
  static const Color warning = Color(0xFFF59E0B); // yellow-500
  static const Color error = Color(0xFFD4183D); // Destructive web
  static const Color info = Color(0xFF0066FF);
  
  // Border Colors - IDENTIQUES AU WEB
  static const Color border = Color(0xFFE5E7EB); // gray-200
  static const Color borderLight = Color(0xFFF3F4F6); // gray-100
  static const Color borderDark = Color(0xFF374151); // gray-700
  
  // Blue shades pour gradient
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  
  // Gradient Colors - IDENTIQUES AU WEB
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0066FF), Color(0xFF0052CC)], // from-[#0066FF] to-[#0052CC]
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transporter / Orange colors (used for transporter flows)
  static const Color transporter = Color(0xFFFF9500);
  static const Color transporterDark = Color(0xFFFF7A00);
  static const LinearGradient transporterGradient = LinearGradient(
    colors: [Color(0xFFFF9500), Color(0xFFFF7A00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
