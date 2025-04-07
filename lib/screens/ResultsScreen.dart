import 'package:flutter/material.dart';
import 'package:who_most_likely_to/screens/HomeScreen.dart';
import 'package:who_most_likely_to/screens/GameRoomScreen.dart';
import 'package:who_most_likely_to/screens/CategorySelectionScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> players;
  final Map<String, int> playerScores;
  final String categoryName;
  final String? roomId;
  final List<String>? externalPeople;
  final Map<String, int>? externalPersonScores;

  const ResultsScreen({
    super.key,
    required this.players,
    required this.playerScores,
    required this.categoryName,
    this.roomId,
    this.externalPeople,
    this.externalPersonScores,
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
    // Combine player scores and external person scores for sorting
    Map<String, int> allScores = {...playerScores};
    if (externalPersonScores != null) {
      allScores.addAll(externalPersonScores!);
    }

    // Sort by score (highest first)
    List<MapEntry<String, int>> sortedScores =
        allScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Final Scores',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Category: $categoryName',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display scores
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Rankings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sortedScores.length,
                        itemBuilder: (context, index) {
                          final entry = sortedScores[index];
                          final isPlayer = players.contains(entry.key);
                          final isExternal =
                              externalPeople?.contains(entry.key) ?? false;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        isPlayer
                                            ? Colors.purple.withOpacity(0.2)
                                            : Colors.orange.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color:
                                            isPlayer
                                                ? Colors.purple
                                                : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (isExternal)
                                        Text(
                                          'External Person',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${entry.value} point${entry.value > 1 ? 's' : ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: SoundButton(
                      soundType: 'click',
                      onPressed: () {
                        if (roomId != null) {
                          if (roomId == 'local_mode') {
                            // For local mode, go back to category selection
                            // and preserve the external people list
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CategorySelectionScreen(
                                      players: players,
                                      preserveExternalPeople: externalPeople,
                                    ),
                              ),
                              (route) => false,
                            );
                          } else {
                            // For online mode, go back to room
                            _resetGameState(context).then((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          GameRoomScreen(roomId: roomId!),
                                ),
                              );
                            });
                          }
                        } else {
                          // For local mode without external voting, go back to category selection
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CategorySelectionScreen(players: players),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        roomId == 'local_mode' || roomId == null
                            ? 'Play Again'
                            : 'Back to Room',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (roomId != null && roomId != 'local_mode') ...[
                    SizedBox(width: 10),
                    Expanded(
                      child: SoundButton(
                        soundType: 'click',
                        onPressed: () {
                          _deleteRoom().then((_) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Leave Room',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (roomId == 'local_mode' || roomId == null) ...[
                    SizedBox(width: 10),
                    Expanded(
                      child: SoundButton(
                        soundType: 'click',
                        onPressed: () {
                          // When going back to home screen, we don't preserve the external people list
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
