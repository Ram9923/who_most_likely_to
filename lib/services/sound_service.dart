import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundEnabled = true;
  bool _isWeb = kIsWeb;

  bool get isSoundEnabled => _isSoundEnabled;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;

    // For web platform, we'll use a different approach
    if (_isWeb) {
      // Initialize web-specific audio handling
      _audioPlayer.setReleaseMode(ReleaseMode.release);
    }

    // Pre-load sound files to ensure they're available
    _preloadSounds();
  }

  // Pre-load all sound files to ensure they're available
  Future<void> _preloadSounds() async {
    try {
      // Create a list of all sound files
      final soundFiles = [
        'sounds/button_click.mp3',
        'sounds/success.mp3',
        'sounds/error.mp3',
        'sounds/game_start.mp3',
        'sounds/vote.mp3',
      ];

      // Pre-load each sound file
      for (final soundFile in soundFiles) {
        try {
          await _audioPlayer.setSource(AssetSource(soundFile));
          print('Pre-loaded sound: $soundFile');
        } catch (e) {
          print('Error pre-loading sound $soundFile: $e');
        }
      }
    } catch (e) {
      print('Error in _preloadSounds: $e');
    }
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _isSoundEnabled);
  }

  Future<void> _playSound(String soundPath) async {
    if (!_isSoundEnabled) return;

    try {
      print('Attempting to play sound: $soundPath');

      if (_isWeb) {
        // For web, use a different approach to avoid download prompts
        await _audioPlayer.stop();

        // Create a new AudioPlayer instance for each sound to avoid conflicts
        final player = AudioPlayer();
        await player.play(AssetSource(soundPath), mode: PlayerMode.mediaPlayer);

        // Clean up the player after the sound finishes
        player.onPlayerComplete.listen((_) {
          player.dispose();
        });
      } else {
        // For mobile platforms, use the regular approach
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(soundPath));
      }

      print('Successfully played sound: $soundPath');
    } catch (e) {
      print('Error playing sound $soundPath: $e');
    }
  }

  Future<void> playButtonClick() async {
    await _playSound('sounds/button_click.mp3');
  }

  Future<void> playSuccess() async {
    await _playSound('sounds/success.mp3');
  }

  Future<void> playError() async {
    await _playSound('sounds/error.mp3');
  }

  Future<void> playGameStart() async {
    await _playSound('sounds/game_start.mp3');
  }

  Future<void> playVote() async {
    await _playSound('sounds/vote.mp3');
  }
}
