import 'package:flutter/material.dart';
import 'package:who_most_likely_to/screens/GameRoomScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HostGameScreen extends StatefulWidget {
  const HostGameScreen({super.key});

  @override
  _HostGameScreenState createState() => _HostGameScreenState();
}

class _HostGameScreenState extends State<HostGameScreen> {
  final TextEditingController roomIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> createRoom() async {
    // Validate the input
    if (roomIdController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill in All fields")));
      return;
    }
    final roomId = roomIdController.text;
    final password = passwordController.text;

    // Get the current user UID
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        // First, get the user's display name from Firebase
        String displayName;
        try {
          final userSnapshot =
              await FirebaseDatabase.instance
                  .ref("players/${currentUser.uid}")
                  .get();

          if (userSnapshot.exists) {
            final userData = userSnapshot.value as Map<dynamic, dynamic>;
            displayName =
                userData['displayName']?.toString() ??
                "Player_${currentUser.uid.substring(0, 4)}";
          } else {
            // If no display name is found, create a fallback
            displayName = "Player_${currentUser.uid.substring(0, 4)}";
            // Save this fallback name to the database
            await FirebaseDatabase.instance
                .ref("players/${currentUser.uid}")
                .set({
                  "uid": currentUser.uid,
                  "displayName": displayName,
                  "joinedAt": DateTime.now().toIso8601String(),
                });
          }
        } catch (e) {
          print("Error fetching user display name: $e");
          // Fallback to a generated name if there's an error
          displayName = "Player_${currentUser.uid.substring(0, 4)}";
        }

        // Create a reference to the database
        final roomRef = FirebaseDatabase.instance.ref('rooms/$roomId');

        // Set the room data in Firebase Realtime Database
        await roomRef.set({
          'roomId': roomId,
          'password': password,
          'hostUid': currentUser.uid,
          'players': {
            currentUser.uid:
                displayName, // Store as a map with UID as key and display name as value
          },
          'createdAt': DateTime.now().toIso8601String(),
          'lastActive':
              ServerValue.timestamp, // Add a timestamp for last activity
        });

        // Debug information
        print("Created room with host display name: $displayName");
        print("Host UID: ${currentUser.uid}");

        // Successfully created the room
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Room created successfully!')));

        // Navigate to the next screen or host the game
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameRoomScreen(roomId: roomId),
          ),
        );
      } catch (e) {
        print("Error creating room: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating room: ${e.toString()}')),
        );
      }
    } else {
      // Handle error if user is not signed in
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: User not signed in')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Room')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: roomIdController,
              decoration: InputDecoration(labelText: 'Enter Room ID'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Enter Room Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createRoom, // Call the function to create the room
              child: Text('Create Room'),
            ),
          ],
        ),
      ),
    );
  }
}
