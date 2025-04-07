import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'GameRoomScreen.dart';
import 'SimultaneousGameScreen.dart';
import 'package:who_most_likely_to/constants/game_categories.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final TextEditingController roomIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> joinRoom() async {
    final roomId = roomIdController.text.trim();
    final password = passwordController.text.trim();

    if (roomId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both Room ID and Password")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final roomRef = FirebaseDatabase.instance.ref("rooms/$roomId");
      final snapshot = await roomRef.get();

      if (!snapshot.exists) throw Exception("Room does not exist");
      final roomData = snapshot.value as Map;
      if (roomData['password'] != password) {
        throw Exception("Incorrect password");
      }

      // Get current user or create anonymous user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        user = userCredential.user;
      }

      if (user == null) throw Exception("Authentication failed");

      // Get the user's display name from Firebase
      String displayName;
      try {
        final userSnapshot =
            await FirebaseDatabase.instance.ref("players/${user.uid}").get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<dynamic, dynamic>;
          displayName =
              userData['displayName']?.toString() ??
              "Player_${Random().nextInt(1000)}";
        } else {
          // If no display name is found, create a random one and save it
          displayName = "Player_${Random().nextInt(1000)}";
          await FirebaseDatabase.instance.ref("players/${user.uid}").set({
            "uid": user.uid,
            "displayName": displayName,
            "joinedAt": DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        print("Error fetching user display name: $e");
        // Fallback to a random name if there's an error
        displayName = "Player_${Random().nextInt(1000)}";
        try {
          await FirebaseDatabase.instance.ref("players/${user.uid}").set({
            "uid": user.uid,
            "displayName": displayName,
            "joinedAt": DateTime.now().toIso8601String(),
          });
        } catch (e) {
          print("Error saving fallback display name: $e");
        }
      }

      // Add player to room with display name
      await roomRef.child("players/${user.uid}").set(displayName);

      // Update the lastActive timestamp
      await roomRef.update({'lastActive': ServerValue.timestamp});

      // Check if game has started
      final gameStarted = roomData['gameStarted'] as bool? ?? false;
      final selectedCategoryKey = roomData['selectedCategory']?.toString();

      if (gameStarted && selectedCategoryKey != null) {
        // Get the category data
        final category = categories[selectedCategoryKey]!;

        // Get the shuffled questions from Firebase
        final shuffledQuestions = List<String>.from(
          roomData['shuffledQuestions'] ?? [],
        );

        // Get all players with their display names
        List<String> playerNames = [];
        Map<String, String> playerDisplayNames = {};

        // First, get all player UIDs
        List<String> playerUids = [];
        if (roomData['players'] is Map) {
          playerUids =
              (roomData['players'] as Map).keys
                  .map((v) => v.toString())
                  .toList();
        } else if (roomData['players'] is List) {
          playerUids =
              (roomData['players'] as List).map((v) => v.toString()).toList();
        }

        // Then fetch display names for each player
        for (String uid in playerUids) {
          try {
            final playerSnapshot =
                await FirebaseDatabase.instance.ref("players/$uid").get();
            if (playerSnapshot.exists) {
              final playerData = playerSnapshot.value as Map<dynamic, dynamic>;
              final playerDisplayName =
                  playerData['displayName']?.toString() ??
                  "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
              playerDisplayNames[uid] = playerDisplayName;
              playerNames.add(playerDisplayName);
            } else {
              // If no display name found, use the value from the room data
              String playerName;
              if (roomData['players'] is Map) {
                playerName =
                    (roomData['players'] as Map)[uid]?.toString() ??
                    "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
              } else {
                playerName =
                    "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
              }
              playerNames.add(playerName);
            }
          } catch (e) {
            print("Error fetching display name for player $uid: $e");
            // Fallback to a generated name
            String playerName =
                "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
            playerNames.add(playerName);
          }
        }

        // Debug information
        print("Joining game with players: $playerNames");
        print("Current user UID: ${user.uid}");

        // Navigate to SimultaneousGameScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => SimultaneousGameScreen(
                  players: playerNames,
                  questions: shuffledQuestions,
                  categoryName: category['name'],
                  categoryColor: category['color'],
                  roomId: roomId,
                  currentUserUid: user!.uid,
                ),
          ),
        );
      } else {
        // Navigate to GameRoomScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameRoomScreen(roomId: roomId),
          ),
        );
      }
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
      appBar: AppBar(title: const Text("Join Game")),
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
                      child: const Text(
                        "Join Game",
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
