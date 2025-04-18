// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:who_most_likely_to/services/firebase_service.dart'; // Import your theme.dart file
import 'dart:math';
import 'PlayerSetupScreen.dart';
import 'DisplayNameScreen.dart';
import 'package:provider/provider.dart';
import 'package:who_most_likely_to/providers/theme_provider.dart';
import 'package:who_most_likely_to/providers/language_provider.dart';
import 'package:who_most_likely_to/widgets/sound_toggle_button.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'package:easy_localization/easy_localization.dart';

class TranslatedText extends StatelessWidget {
  final String keyName;
  final TextStyle? style;

  const TranslatedText(this.keyName, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      keyName.tr(), // Translate using EasyLocalization
      style: style, // Apply the style if provided
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Who\'s Most Likely To'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'عربي',
                  style: TextStyle(
                    fontWeight:
                        languageProvider.isArabic
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        (themeProvider.isDarkMode
                            ? (languageProvider.isArabic
                                ? Colors.white
                                : Colors.grey)
                            : (languageProvider.isArabic
                                ? Colors.purple
                                : Colors.grey)),
                  ),
                ),
                Switch(
                  value: !languageProvider.isArabic,
                  onChanged: (value) {
                    languageProvider.toggleLanguage(context);
                  },
                  activeColor: Colors.purple,
                  activeTrackColor: Colors.purple.withOpacity(0.5),
                  inactiveThumbColor: Colors.purple,
                  inactiveTrackColor: Colors.purple.withOpacity(0.5),
                  trackOutlineColor: MaterialStateProperty.all(Colors.purple),
                ),

                Text(
                  'EN',
                  style: TextStyle(
                    fontWeight:
                        !languageProvider.isArabic
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        (themeProvider.isDarkMode
                            ? (!languageProvider.isArabic
                                ? Colors.white
                                : Colors.grey)
                            : (!languageProvider.isArabic
                                ? Colors.purple
                                : Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
          const SoundToggleButton(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: const Icon(
                  Icons.gamepad,
                  size: 120,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 40),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  'Welcome'.tr(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'A fun party game to play with friends'.tr(),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: SoundButton(
                  soundType: 'click',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const PlayerSetupScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text('Local'.tr(), style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 30),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: SoundButton(
                  soundType: 'click',
                  onPressed: () async {
                    final user = await signInAnonymously();
                    if (user != null) {
                      await addUserToDatabase(
                        user,
                        "Player_${Random().nextInt(100)}",
                      );

                      // Navigate only after Firebase operations succeed
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const DisplayNameScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    } else {
                      // Optional: Show error to user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to join. Please try again.'.tr(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Online'.tr(), style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
