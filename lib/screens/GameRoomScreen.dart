// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who_most_likely_to/constants/game_categories.dart';
import 'package:who_most_likely_to/screens/SimultaneousGameScreen.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';

class GameRoomScreen extends StatefulWidget {
  final String roomId;

  const GameRoomScreen({super.key, required this.roomId});

  @override
  _GameRoomScreenState createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  late String? currentUserUid;
  String? roomHostUid;
  List<String> playerUids = [];
  Map<String, String> playerDisplayNames = {};
  StreamSubscription<DatabaseEvent>? _roomSubscription;
  StreamSubscription<DatabaseEvent>? _playersSubscription;

  @override
  void dispose() {
    _roomSubscription?.cancel();
    _playersSubscription?.cancel();
    super.dispose();
  }

  // Add a variable to store the selected category
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    _listenToRoomChanges();
    _resetGameState();
  }

  void _listenToRoomChanges() {
    try {
      final roomRef = FirebaseDatabase.instance.ref('rooms/${widget.roomId}');
      _roomSubscription = roomRef.onValue.listen(
        (event) {
          if (!mounted) return; // Check if widget is still mounted

          try {
            final data = event.snapshot.value as Map<dynamic, dynamic>?;

            if (data == null) return;

            final host = data['hostUid']?.toString();
            final playersData = data['players'];
            final gameStarted = data['gameStarted'] as bool? ?? false;
            final selectedCategoryKey = data['selectedCategory']?.toString();
            final shuffledQuestions =
                data['shuffledQuestions'] as List<dynamic>?;

            // Handle players data properly
            List<String> playersList = [];
            Map<String, String> displayNames = {};

            if (playersData is Map) {
              // New format: players is a map with UIDs as keys and display names as values
              playersList = playersData.keys.map((v) => v.toString()).toList();
              playersData.forEach((key, value) {
                displayNames[key.toString()] = value.toString();
              });
            } else if (playersData is List) {
              // Old format: players is a list of UIDs
              playersList = playersData.map((v) => v.toString()).toList();
            }

            setState(() {
              roomHostUid = host;
              playerUids = playersList;
              playerDisplayNames = displayNames;
              selectedCategory = selectedCategoryKey;
            });

            // If game has started and we're not the host, navigate to game screen
            if (gameStarted &&
                currentUserUid != roomHostUid &&
                selectedCategory != null &&
                shuffledQuestions != null) {
              final category = categories[selectedCategory]!;

              // Get display names for all players
              List<String> displayNamesList =
                  playerUids
                      .map(
                        (uid) =>
                            playerDisplayNames[uid] ??
                            "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}",
                      )
                      .toList();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SimultaneousGameScreen(
                        players: displayNamesList,
                        questions:
                            shuffledQuestions.map((e) => e.toString()).toList(),
                        categoryName: category['name'],
                        categoryColor: category['color'],
                        roomId: widget.roomId,
                        currentUserUid: currentUserUid!,
                      ),
                ),
              );
            }
          } catch (e) {
            print('Error processing room data: $e');
          }
        },
        onError: (error) {
          if (!mounted) return; // Check if widget is still mounted
          print('Error in room listener: $error');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${error.message}')));
        },
      );
    } catch (e) {
      if (!mounted) return; // Check if widget is still mounted
      print('Error setting up room listener: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _fetchPlayerDisplayNames(List<String> playerUids) {
    // Cancel previous subscription if any
    _playersSubscription?.cancel();

    // Create a map to store player display names
    Map<String, String> displayNames = {};

    // Listen to changes in the players collection
    for (String uid in playerUids) {
      FirebaseDatabase.instance
          .ref('players/$uid')
          .onValue
          .listen(
            (event) {
              if (!mounted) return; // Check if widget is still mounted

              try {
                if (event.snapshot.value != null) {
                  final data = event.snapshot.value as Map<dynamic, dynamic>;
                  final displayName =
                      data['displayName']?.toString() ??
                      "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";

                  setState(() {
                    playerDisplayNames[uid] = displayName;
                  });
                } else {
                  // If no display name found, use a fallback
                  setState(() {
                    playerDisplayNames[uid] =
                        "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
                  });
                }
              } catch (e) {
                print('Error fetching display name for $uid: $e');
                setState(() {
                  playerDisplayNames[uid] =
                      "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
                });
              }
            },
            onError: (error) {
              print('Error in player display name listener for $uid: $error');
              if (mounted) {
                setState(() {
                  playerDisplayNames[uid] =
                      "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}";
                });
              }
            },
          );
    }
  }

  // Function to start the game
  void _startGame() async {
    if (currentUserUid == roomHostUid) {
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a category before starting the game'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final category = categories[selectedCategory]!;

      // Create shuffled questions
      final random = Random();
      final shuffledQuestions = [...List<String>.from(category['questions'])]
        ..shuffle(random);

      // Get display names for all players directly from the room data
      List<String> displayNames =
          playerUids
              .map(
                (uid) =>
                    playerDisplayNames[uid] ??
                    "Player_${uid.length > 4 ? uid.substring(0, 4) : uid}",
              )
              .toList();

      // Update room state in Firebase
      await FirebaseDatabase.instance.ref('rooms/${widget.roomId}').update({
        'gameStarted': true,
        'selectedCategory': selectedCategory,
        'gameType': 'simultaneous',
        'currentQuestion': {'index': 0, 'showingResults': false},
        'shuffledQuestions': shuffledQuestions,
        'lastActive': ServerValue.timestamp, // Update lastActive timestamp
      });

      // Clear any existing votes
      await FirebaseDatabase.instance
          .ref('rooms/${widget.roomId}/votes')
          .remove();

      // Debug information
      print('Starting game with players: $displayNames');
      print('Current user UID: $currentUserUid');
      print('Room host UID: $roomHostUid');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => SimultaneousGameScreen(
                players: displayNames,
                questions: shuffledQuestions,
                categoryName: category['name'],
                categoryColor: category['color'],
                roomId: widget.roomId,
                currentUserUid: currentUserUid!,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Only the host can start the game'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to select a category
  void _selectCategory(String categoryKey) {
    if (currentUserUid == roomHostUid) {
      setState(() {
        selectedCategory = categoryKey;
      });

      // Update Firebase with the selected category
      FirebaseDatabase.instance.ref('rooms/${widget.roomId}').update({
        'selectedCategory': categoryKey,
        'lastActive': ServerValue.timestamp,
      });
    }
  }

  // Add a method to reset the game state
  Future<void> _resetGameState() async {
    try {
      await FirebaseDatabase.instance.ref('rooms/${widget.roomId}').update({
        'gameStarted': false,
        'selectedCategory': null,
        'currentQuestion': null,
        'shuffledQuestions': null,
        'votes': null,
        'resultsTimestamp': ServerValue.timestamp,
        'lastActive': ServerValue.timestamp, // Update lastActive timestamp
      });

      setState(() {
        selectedCategory = null;
      });

      print('Game state reset successfully');
    } catch (e) {
      print('Error resetting game state: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room: ${widget.roomId}'),
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
                        'Room ID: ${widget.roomId}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Players in this room:',
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
              // Display the list of players with their display names
              Container(
                height: 200, // Fixed height for player list
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlayerList(
                      playerUids: playerUids,
                      playerDisplayNames: playerDisplayNames,
                      roomHostUid: roomHostUid,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Only show the Start Game button if the current user is the host
              SoundButton(
                soundType: 'gameStart',
                onPressed:
                    roomHostUid != null && currentUserUid == roomHostUid
                        ? () => _startGame()
                        : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Start Game',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              // Display category buttons
              Container(
                height: 300, // Fixed height for category selector
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CategorySelector(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onSelectCategory: _selectCategory,
                      roomHostUid: roomHostUid,
                      currentUserUid: currentUserUid,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Show selected category (if any)
              if (selectedCategory != null)
                Card(
                  elevation: 4,
                  color: categories[selectedCategory]!['color'].withOpacity(
                    0.2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          categories[selectedCategory]!['icon'],
                          color: categories[selectedCategory]!['color'],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Selected Category: ${categories[selectedCategory]!['name']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerList extends StatelessWidget {
  final List<String> playerUids;
  final Map<String, String> playerDisplayNames;
  final String? roomHostUid;

  const PlayerList({
    super.key,
    required this.playerUids,
    required this.playerDisplayNames,
    required this.roomHostUid,
  });

  @override
  Widget build(BuildContext context) {
    if (playerUids.isEmpty) {
      return Center(
        child: Text(
          'No players in the room yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: playerUids.length,
      itemBuilder: (context, index) {
        final playerUid = playerUids[index];
        final displayName =
            playerDisplayNames[playerUid] ??
            "Player_${playerUid.length > 4 ? playerUid.substring(0, 4) : playerUid}";
        final isHost = playerUid == roomHostUid;

        return ListTile(
          leading: CircleAvatar(child: Text(displayName[0].toUpperCase())),
          title: Text(displayName, overflow: TextOverflow.ellipsis),
          trailing: isHost ? const Icon(Icons.star, color: Colors.amber) : null,
        );
      },
    );
  }
}

class CategorySelector extends StatelessWidget {
  final Map<String, Map<String, dynamic>> categories;
  final String? selectedCategory;
  final Function(String) onSelectCategory;
  final String? roomHostUid;
  final String? currentUserUid;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.roomHostUid,
    required this.currentUserUid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select a Category:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryKey = categories.keys.elementAt(index);
              final category = categories[categoryKey];
              final isSelected = selectedCategory == categoryKey;
              final isHost =
                  roomHostUid != null && currentUserUid == roomHostUid;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SoundButton(
                  soundType: 'click',
                  onPressed:
                      isHost ? () => onSelectCategory(categoryKey) : () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      isSelected ? category!['color'] : Colors.grey.shade300,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? category!['color']
                                  : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category!['icon'],
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
