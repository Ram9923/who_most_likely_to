import 'package:flutter/material.dart';
import 'package:who_most_likely_to/services/sound_service.dart';

class SoundIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final double? iconSize;
  final String? tooltip;
  final bool playSound;
  final String soundType;

  const SoundIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.iconSize,
    this.tooltip,
    this.playSound = true,
    this.soundType = 'click',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: iconSize),
      tooltip: tooltip,
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
    );
  }
}
