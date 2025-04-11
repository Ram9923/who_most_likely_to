import 'package:flutter/material.dart';
import 'package:who_most_likely_to/screens/HostGameScreen.dart';
import 'package:who_most_likely_to/screens/JoinGameScreen.dart';
import 'package:who_most_likely_to/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class HostJoinScreen extends StatelessWidget {
  const HostJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Who\'s Most Likely To'.tr())),
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
                  'Choose Your Role'.tr(),
                  style: AppTheme.getTitleTextStyle(context),
                ),
              ),
              const SizedBox(height: 60),
              // Host Button
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: ElevatedButton(
                  style: AppTheme.getElevatedButtonStyle(context),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const HostGameScreen(), // Navigate to HostGameScreen
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
                  child:  Text(
                    'Host Game'.tr(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Join Button
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: ElevatedButton(
                  style: AppTheme.getElevatedButtonStyle(context),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const JoinGameScreen(), // Navigate to JoinGameScreen
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
                  child:  Text(
                    'Join Game'.tr(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
