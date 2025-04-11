import 'package:flutter/material.dart';
import 'package:who_most_likely_to/screens/HomeScreen.dart';
import 'package:who_most_likely_to/screens/GameRoomScreen.dart';
import 'package:who_most_likely_to/screens/CategorySelectionScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'package:who_most_likely_to/utils/localization_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> players;
  final Map<String, int> playerScores;
  final Map<String, String> categoryName;
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
    print('ResultsScreen - build called');
    print('Players: $players');
    print('Player Scores: $playerScores');
    print('External People: $externalPeople');
    print('External Person Scores: $externalPersonScores');
    print('Category Name: $categoryName');
    print('Room ID: $roomId');

    // Combine player scores and external person scores for sorting
    Map<String, int> allScores = {...playerScores};
    print('Initial allScores (player scores): $allScores');

    if (externalPersonScores != null) {
      print('Adding external person scores to allScores');
      allScores.addAll(externalPersonScores!);
    }
    print('Final allScores after combining: $allScores');

    // Sort by score (highest first)
    List<MapEntry<String, int>> sortedScores =
        allScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    print('Sorted Scores: $sortedScores');
    print('Sorted Scores length: ${sortedScores.length}');

    // Debug information
    print('Players: $players');
    print('Player Scores: $playerScores');
    print('External People: $externalPeople');
    print('External Person Scores: $externalPersonScores');
    print('All Scores: $allScores');
    print('Sorted Scores: $sortedScores');

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'.tr()),
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
                        'Final Scores'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Category: ${getLocalizedText(context, categoryName)}',
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
              // Scores list
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Rankings'.tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      sortedScores.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'No scores recorded'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: sortedScores.length,
                            itemBuilder: (context, index) {
                              print('Building item at index: $index');
                              print(
                                'Sorted scores length: ${sortedScores.length}',
                              );

                              if (index >= sortedScores.length) {
                                print(
                                  'Index out of range: $index >= ${sortedScores.length}',
                                );
                                return SizedBox.shrink(); // Return an empty widget if index is out of range
                              }

                              final entry = sortedScores[index];
                              print('Entry at index $index: $entry');

                              final isPlayer = players.contains(entry.key);
                              final isExternal =
                                  externalPeople?.contains(entry.key) ?? false;
                              print(
                                'Is player: $isPlayer, Is external: $isExternal',
                              );

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            isPlayer
                                                ? Colors.purple.withOpacity(0.2)
                                                : Colors.orange.withOpacity(
                                                  0.2,
                                                ),
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
                                              'Non Player'.tr(),
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
                                      preserveExternalPeople:
                                          externalPeople ?? [],
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
                            ? 'Play Again'.tr()
                            : 'Back to Room'.tr(),
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
                          'Leave Room'.tr(),
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
                          'Back to Home'.tr(),
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
