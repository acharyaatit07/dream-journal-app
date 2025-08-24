// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Warm and Natural (inspired by the meditation app design)
  static const Color primary = Color(0xFF2D5016); // Deep forest green
  static const Color primaryDark = Color(0xFF1F3A0F); // Darker forest green
  static const Color primaryLight = Color(0xFF4A7C2A); // Lighter forest green

  // Accent Colors - Warm peach/coral tones
  static const Color accent = Color(0xFFFF9F80); // Soft coral
  static const Color accentLight = Color(0xFFFFB4A0); // Light peach
  static const Color accentDark = Color(0xFFE67350); // Deeper coral

  // Background Colors - Soft and warm
  static const Color backgroundLight = Color(0xFFFFF8F6); // Warm off-white
  static const Color backgroundDark = Color(0xFF1C1B1A); // Warm dark
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceDark = Color(0xFF2A2926); // Warm dark surface

  // Card Colors - Soft with warm undertones
  static const Color cardLight = Color(0xFFFFFFFF); // White cards
  static const Color cardDark = Color(0xFF353330); // Warm dark cards
  static const Color cardPeach = Color(0xFFFFF0ED); // Very light peach
  static const Color cardGreen = Color(0xFFF0F7EC); // Very light green

  // Text Colors - Natural and readable
  static const Color textPrimaryLight = Color(0xFF2A2926); // Warm black
  static const Color textPrimaryDark = Color(0xFFFAF9F8); // Warm white
  static const Color textSecondaryLight = Color(0xFF6B6A67); // Warm gray
  static const Color textSecondaryDark = Color(0xFFA8A6A3); // Light warm gray
  static const Color textTertiaryLight = Color(0xFF9B9A97); // Light gray
  static const Color textTertiaryDark = Color(0xFF5A5956); // Medium gray

  // Border Colors - Soft and natural
  static const Color borderLight = Color(0xFFEBE9E6); // Warm light border
  static const Color borderDark = Color(0xFF403E3B); // Warm dark border

  // Natural Green Variations - For different UI elements
  static const Color leafGreen = Color(0xFF52734A); // Medium leaf green
  static const Color softGreen = Color(0xFF7BA05B); // Soft nature green
  static const Color paleGreen = Color(0xFFA8C68F); // Pale green

  // Peach/Coral Variations
  static const Color softPeach = Color(0xFFFFD4C8); // Very soft peach
  static const Color warmCoral = Color(0xFFFFA285); // Warm coral
  static const Color deepCoral = Color(0xFFFF7A50); // Deep coral

  // Dream Category Colors - Natural and muted
  static const Color nightmareColor = Color(0xFFD47559); // Muted warm red
  static const Color lucidColor = Color(0xFF9B7EAF); // Muted lavender
  static const Color flyingColor = Color(0xFF7BA8C7); // Muted sky blue
  static const Color adventureColor = Color(0xFF52734A); // Forest green
  static const Color romanceColor = Color(0xFFE6A4B4); // Soft rose
  static const Color fantasyColor = Color(0xFFB08FC7); // Soft purple
  static const Color memoryColor = Color(0xFF8A8570); // Warm taupe
  static const Color otherColor = Color(0xFF6B6A67); // Warm gray

  // Mood Colors - Warm and natural progression
  static const List<Color> moodColors = [
    Color(0xFFD47559), // Terrible - Warm muted red
    Color(0xFFE88B6B), // Bad - Lighter warm red
    Color(0xFFED9F7C), // Poor - Warm orange
    Color(0xFFF5B041), // Okay - Warm golden
    Color(0xFFB8D482), // Good - Soft green
    Color(0xFF8BC267), // Great - Fresh green
    Color(0xFF6FAA4F), // Amazing - Vibrant green
  ];

  // Sleep Quality Colors - Natural progression
  static const List<Color> sleepQualityColors = [
    Color(0xFFD47559), // Very Poor - Warm red
    Color(0xFFED9F7C), // Poor - Warm orange
    Color(0xFFF5B041), // Fair - Golden
    Color(0xFFB8D482), // Good - Soft green
    Color(0xFF6FAA4F), // Excellent - Vibrant green
  ];

  // Lucidity Colors - Dreamy progression
  static const List<Color> lucidityColors = [
    Color(0xFF8A8570), // Not Lucid - Warm taupe
    Color(0xFF7BA8C7), // Slightly Aware - Sky blue
    Color(0xFF9B7EAF), // Somewhat Lucid - Lavender
    Color(0xFFB08FC7), // Very Lucid - Soft purple
    Color(0xFF9966CC), // Fully Lucid - Dream purple
  ];

  // Status Colors - Natural and warm
  static const Color success = Color(0xFF52734A); // Forest green
  static const Color warning = Color(0xFFF5B041); // Golden yellow
  static const Color error = Color(0xFFD47559); // Warm red
  static const Color info = Color(0xFF7BA8C7); // Sky blue

  // Natural Gradients - Inspired by nature
  static const LinearGradient peachGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF0ED), Color(0xFFFFE4DE)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0F7EC), Color(0xFFE8F1E1)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF8F6), Color(0xFFFFF0ED)],
  );

  static const LinearGradient naturalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F80), Color(0xFF52734A)],
    stops: [0.0, 1.0],
  );

  // Shadow Colors - Warm and subtle
  static const Color shadowWarm = Color(0x08D47559); // Warm shadow
  static const Color shadowLight = Color(0x05000000); // Very subtle
  static const Color shadowMedium = Color(0x0A000000); // Subtle

  // Special Background Colors - For different dream types
  static const Color dreamCardBackground = Color(0xFFFFFBFA); // Warm white
  static const Color nightmareCardBackground =
      Color(0xFFFEF7F5); // Very light peach
  static const Color lucidCardBackground =
      Color(0xFFFAF7FC); // Very light lavender
  static const Color flyingCardBackground =
      Color(0xFFF5F9FC); // Very light blue
  static const Color peachyBackground =
      Color(0xFFFFF4F1); // Soft peachy background
  static const Color leafyBackground =
      Color(0xFFF7FAF5); // Soft green background

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

  // Helper method to get category background color
  static Color getDreamCategoryBackground(String category) {
    switch (category.toLowerCase()) {
      case 'nightmare':
        return nightmareCardBackground;
      case 'lucid dream':
        return lucidCardBackground;
      case 'flying dream':
        return flyingCardBackground;
      case 'adventure':
        return leafyBackground;
      case 'romance':
        return peachyBackground;
      default:
        return dreamCardBackground;
    }
  }

  // Helper method to get sleep quality color
  static Color getSleepQualityColor(int quality) {
    if (quality < 1 || quality > 5) return sleepQualityColors[2];
    return sleepQualityColors[quality - 1];
  }

  // Helper method to get lucidity color
  static Color getLucidityColor(int level) {
    if (level < 0 || level > 4) return lucidityColors[0];
    return lucidityColors[level];
  }

  // Natural color variations for UI elements
  static const Color buttonPeach = Color(0xFFFFB4A0);
  static const Color buttonGreen = Color(0xFF52734A);
  static const Color chipBackground = Color(0xFFF7F4F2);
  static const Color chipBorder = Color(0xFFE8E3DF);
}
