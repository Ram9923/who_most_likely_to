// DisplayNameScreen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who_most_likely_to/screens/HostJoinScreen.dart';
import 'package:who_most_likely_to/theme.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'package:easy_localization/easy_localization.dart';

class DisplayNameScreen extends StatefulWidget {
  const DisplayNameScreen({super.key});

  @override
  State<DisplayNameScreen> createState() => _DisplayNameScreenState();
}

class _DisplayNameScreenState extends State<DisplayNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveDisplayName() async {
    final displayName = _nameController.text.trim();

    if (displayName.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a display name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user or create anonymous user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        try {
          final userCredential =
              await FirebaseAuth.instance.signInAnonymously();
          user = userCredential.user;
        } catch (e) {
          print("Error signing in anonymously: $e");
          throw Exception('Failed to authenticate user: $e');
        }
      }

      if (user == null) {
        throw Exception('Failed to authenticate user');
      }

      // Save display name to Firebase
      try {
        await FirebaseDatabase.instance.ref('players/${user.uid}').set({
          'uid': user.uid,
          'displayName': displayName,
          'lastUpdated': DateTime.now().toIso8601String(),
        });

        print(
          "Successfully saved display name: $displayName for user: ${user.uid}",
        );
      } catch (e) {
        print("Error saving display name to Firebase: $e");
        throw Exception('Failed to save display name: $e');
      }

      // Navigate to host/join screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HostJoinScreen()),
        );
      }
    } catch (e) {
      print("Error in _saveDisplayName: $e");
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Enter Your Name'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.purple),
            const SizedBox(height: 30),
            Text(
              'What should we call you?'.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'This name will be displayed to other players'.tr(),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: AppTheme.getTextFieldInputDecoration(context),
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => _saveDisplayName(),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : SoundButton(
                  soundType: 'click',
                  onPressed: _saveDisplayName,
                  style: AppTheme.getElevatedButtonStyle(context),
                  child:  Text('Continue'.tr(), style: TextStyle(fontSize: 18)),
                ),
          ],
        ),
      ),
    );
  }
}
