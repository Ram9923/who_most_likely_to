import 'package:flutter/material.dart';
import 'package:who_most_likely_to/screens/HomeScreen.dart';
import 'package:who_most_likely_to/screens/GameRoomScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> players;
  final Map<String, int> playerScores;
  final String categoryName;
  final String? roomId;

  const ResultsScreen({
    super.key,
    required this.players,
    required this.playerScores,
    required this.categoryName,
    this.roomId,
  });

  Future<void> _resetGameState(BuildContext context) async {
    if (roomId != null) {
      try {
        await FirebaseDatabase.instance.ref('rooms/$roomId').update({
          'gameStarted': false,
          'selectedCategory': null,
          'currentQuestion': null,
          'shuffledQuestions': null,
          'votes': null,
          'resultsTimestamp': ServerValue.timestamp,
        });

        print(
          'Game state reset successfully before navigating to GameRoomScreen',
        );
      } catch (e) {
        print('Error resetting game state: $e');
      }
    }
  }

  Future<void> _deleteRoom() async {
    if (roomId != null) {
      try {
        await FirebaseDatabase.instance.ref('rooms/$roomId').remove();
        print('Room deleted successfully: $roomId');
      } catch (e) {
        print('Error deleting room: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort players by scores (descending)
    List<String> sortedPlayers = List.from(players);
    sortedPlayers.sort(
      (a, b) => (playerScores[b] ?? 0).compareTo(playerScores[a] ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
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
                '$categoryName Results',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Final Tally - Who\'s Most Likely To...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: sortedPlayers.length,
                itemBuilder: (context, index) {
                  String player = sortedPlayers[index];
                  int score = playerScores[player] ?? 0;

                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(50 * (1 - value), 0),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: index == 0 ? 8 : 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: index == 0 ? Colors.yellow[100] : Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(player[0].toUpperCase()),
                        ),
                        title: Text(player),
                        trailing: Text(
                          '$score votes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SoundButton(
                  soundType: 'click',
                  onPressed: () async {
                    if (roomId != null) {
                      await _resetGameState(context);
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Play Again'),
                ),
                SoundButton(
                  soundType: 'click',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
