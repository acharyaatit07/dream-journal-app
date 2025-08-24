// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Dream-themed
  static const Color primary = Color(0xFF6B73FF);
  static const Color primaryDark = Color(0xFF5A61E6);
  static const Color primaryLight = Color(0xFF8B92FF);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  
  // Dream Category Colors
  static const Color nightmareColor = Color(0xFFD32F2F);
  static const Color lucidColor = Color(0xFF7B1FA2);
  static const Color flyingColor = Color(0xFF1976D2);
  static const Color adventureColor = Color(0xFF388E3C);
  static const Color romanceColor = Color(0xFFE91E63);
  static const Color fantasyColor = Color(0xFF9C27B0);
  static const Color memoryColor = Color(0xFF795548);
  static const Color otherColor = Color(0xFF607D8B);
  
  // Mood Colors (1-7 scale)
  static const List<Color> moodColors = [
    Color(0xFFD32F2F), // Terrible - Red
    Color(0xFFFF5722), // Bad - Orange Red  
    Color(0xFFFF9800), // Poor - Orange
    Color(0xFFFFC107), // Okay - Amber
    Color(0xFF8BC34A), // Good - Light Green
    Color(0xFF4CAF50), // Great - Green
    Color(0xFF2E7D32), // Amazing - Dark Green
  ];
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFD32F2F);
  
  // Gradients
  static const LinearGradient dreamGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );
  
  // Helper method to get mood color
  static Color getMoodColor(int mood) {
    if (mood < 1 || mood > 7) return moodColors[3]; // Default to "Okay"
    return moodColors[mood - 1];
  }
  
  // Helper method to get dream category color
  static Color getDreamCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'nightmare':
        return nightmareColor;
      case 'lucid dream':
        return lucidColor;
      case 'flying dream':
        return flyingColor;
      case 'adventure':
        return adventureColor;
      case 'romance':
        return romanceColor;
      case 'fantasy':
        return fantasyColor;
      case 'memory':
        return memoryColor;
      default:
        return otherColor;
    }
  }
}