import 'package:flutter/material.dart';
import 'package:who_most_likely_to/services/sound_service.dart';

class SoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool playSound;
  final String soundType;

  const SoundButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.playSound = true,
    this.soundType = 'click',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (playSound && SoundService().isSoundEnabled) {
          switch (soundType) {
            case 'click':
              SoundService().playButtonClick();
              break;
            case 'success':
              SoundService().playSuccess();
              break;
            case 'error':
              SoundService().playError();
              break;
            case 'gameStart':
              SoundService().playGameStart();
              break;
            case 'vote':
              SoundService().playVote();
              break;
          }
        }
        onPressed();
      },
      child: child,
    );
  }
}
