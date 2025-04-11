import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'GameRoomScreen.dart';
import 'SimultaneousGameScreen.dart';
import 'package:who_most_likely_to/constants/game_categories.dart';
import 'package:easy_localization/easy_localization.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final TextEditingController roomIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> joinRoom() async {
    setState(() => isLoading = true);

    try {
      final roomId = roomIdController.text.trim();
      final password = passwordController.text.trim();

      if (roomId.isEmpty) {
        throw "Please enter a room ID";
      }

      if (password.isEmpty) {
        throw "Please enter a password";
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw "You must be logged in to join a game";
      }

      // Get room data from Firebase
      final roomRef = FirebaseDatabase.instance.ref('rooms/$roomId');
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        throw "Room not found";
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      final roomPassword = data['password']?.toString();

      if (roomPassword != password) {
        throw "Incorrect password";
      }

      // Add player to room
      String displayName;
      try {
        final userSnapshot =
            await FirebaseDatabase.instance.ref("players/${user.uid}").get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<dynamic, dynamic>;
          displayName =
              userData['displayName']?.toString() ??
              "Player_${user.uid.substring(0, 4)}";
        } else {
          // If no display name is found, create a fallback
          displayName = "Player_${user.uid.substring(0, 4)}";
          // Save this fallback name to the database
          await FirebaseDatabase.instance.ref("players/${user.uid}").set({
            "uid": user.uid,
            "displayName": displayName,
            "joinedAt": DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        print("Error fetching user display name: $e");
        displayName = "Player_${user.uid.substring(0, 4)}";
      }

      // Add player to room with their display name
      await roomRef.child('players/${user.uid}').set(displayName);

      // Navigate to GameRoomScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GameRoomScreen(roomId: roomId)),
      );
    } catch (e) {
      print("Error joining room: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join Game".tr())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.vpn_key, size: 100, color: Colors.purple),
                const SizedBox(height: 30),
                TextField(
                  controller: roomIdController,
                  decoration: const InputDecoration(labelText: "Room ID"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      onPressed: joinRoom,
                      child: Text(
                        "Join Game".tr(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
