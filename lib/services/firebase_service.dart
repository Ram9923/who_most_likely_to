import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

Future<User?> signInAnonymously() async {
  try {
    final result = await FirebaseAuth.instance.signInAnonymously();
    final user = result.user;
    print('Signed in anonymously as: ${user?.uid}');

    // Set a default display name, this can be updated later
    final userRef = FirebaseDatabase.instance.ref("players/${user!.uid}");

    await userRef.set({
      "uid": user.uid,
      "nickname":
          "Player_${Random().nextInt(100)}", // You can replace this with a prompt for a name
    });

    return user;
  } catch (e) {
    print('Anonymous sign-in failed: $e');
    return null;
  }
}

Future<void> addUserToDatabase(User user, String displayName) async {
  // Save player info in the database with their display name
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref(
    "players/${user.uid}",
  );
  await dbRef.set({
    "uid": user.uid,
    "displayName": displayName,
    "joinedAt": DateTime.now().toIso8601String(),
  });
}
