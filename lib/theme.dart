// theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // TextStyle for title
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

  // TextStyle for body text
  static TextStyle getBodyTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black87,
    );
  }

  // ElevatedButton Style
  static ButtonStyle getElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.purple.shade700
              : Colors.purple,
    );
  }

  // AppBar style
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

  // TextField Input Decoration
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
}
