import 'package:flutter/material.dart';
import 'package:who_most_likely_to/services/sound_service.dart';

class SoundToggleButton extends StatefulWidget {
  const SoundToggleButton({super.key});

  @override
  State<SoundToggleButton> createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends State<SoundToggleButton> {
  bool _isSoundEnabled = true;

  @override
  void initState() {
    super.initState();
    _isSoundEnabled = SoundService().isSoundEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isSoundEnabled ? Icons.volume_up : Icons.volume_off,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        setState(() {
          _isSoundEnabled = !_isSoundEnabled;
        });
        SoundService().toggleSound();
        // Play a sound to indicate the toggle (if sound is enabled)
        if (_isSoundEnabled) {
          SoundService().playButtonClick();
        }
      },
      tooltip: _isSoundEnabled ? 'Mute Sounds' : 'Unmute Sounds',
    );
  }
}
