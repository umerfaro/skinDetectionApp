import 'package:flutter/material.dart';

// --- Application Color Constants ---
// This class holds all the color constants for the application.

class AppColors {
  // This class is not meant to be instantiated.
  AppColors._();

  // --- Primary Palette ---
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF1A3A3A);
  static const Color background = Color(0xFF0D1A1A);

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimaryButton = Colors.white;
  static const Color white = Color.fromARGB(255, 137, 77, 77);

  // --- Button Colors ---
  static const Color primaryButton = Color(0xFF6366F1);
  static const Color secondaryButton = Color(0xFFF3F4F6);

  // --- Icon Colors ---
  static const Color iconOnPrimaryButton = Colors.white;
  static const Color iconOnSecondaryButton = Color(0xFF6B7280);

  // --- Background Colors ---
  static const Color cardBackground = Color(0xFF6366F1);
}
