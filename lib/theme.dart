// theme.dart

import 'package:flutter/material.dart';

// Color Schemes
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6A1B9A); // Deep Purple
  static const Color primaryLight = Color(0xFF9C4DFF);
  static const Color primaryDark = Color(0xFF38006B);

  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50); // Green
  static const Color secondaryLight = Color(0xFF80E27E);
  static const Color secondaryDark = Color(0xFF087F23);

  // Accent Colors
  static const Color accent = Color(0xFFFFC107); // Amber
  static const Color accentLight = Color(0xFFFFF350);
  static const Color accentDark = Color(0xFFC79100);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;

  // Game Specific Colors
  static const Color playerCard = Color(0xFFE3F2FD);
  static const Color voteButton = Color(0xFF4CAF50);
  static const Color resultsBackground = Color(0xFFF5F5F5);
  static const Color winnerHighlight = Color(0xFFFFD700);
}

// Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );
}

// Button Styles
class AppButtonStyles {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.textOnSecondary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle accentButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.accent,
    foregroundColor: AppColors.textPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

// Card Styles
class AppCardStyles {
  static BoxDecoration defaultCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration playerCard = BoxDecoration(
    color: AppColors.playerCard,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

// Input Styles
class AppInputStyles {
  static InputDecoration textField = InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

// App Theme
class AppTheme {
  // Method-based approach for backward compatibility
  static TextStyle getTitleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
    );
  }

  static TextStyle getBodyTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black87,
    );
  }

  static ButtonStyle getElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.purple.shade700
              : Colors.purple,
    );
  }

  static AppBarTheme getAppBarTheme(BuildContext context) {
    return AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.purple.shade900
              : Colors.purple,
    );
  }

  static InputDecoration getTextFieldInputDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: 'Enter player name',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          color: isDark ? Colors.purple.shade300 : Colors.blue,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey,
          width: 1.0,
        ),
      ),
      filled: true,
      fillColor: isDark ? Colors.grey.shade800 : Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      hintStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey),
    );
  }

  // Theme Data
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.primaryButton,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.heading1,
      displayMedium: AppTextStyles.heading2,
      displaySmall: AppTextStyles.heading3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
