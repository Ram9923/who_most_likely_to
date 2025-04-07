// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:who_most_likely_to/screens/ResultsScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_most_likely_to/screens/GameRoomScreen.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';

class SimultaneousGameScreen extends StatefulWidget {
  final List<String> players;
  final List<String> questions;
  final String categoryName;
  final Color categoryColor;
  final String roomId;
  final String currentUserUid;

  const SimultaneousGameScreen({
    super.key,
    required this.players,
    required this.questions,
    required this.categoryName,
    required this.categoryColor,
    required this.roomId,
    required this.currentUserUid,
  });

  @override
  _SimultaneousGameScreenState createState() => _SimultaneousGameScreenState();
}

class _SimultaneousGameScreenState extends State<SimultaneousGameScreen>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  Map<String, List<String>> questionVotes = {};
  Map<String, Map<String, String>> playerVotes = {};
  Map<String, int> playerScores = {};
  bool showingResults = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<String> shuffledQuestions;
  String? currentUserUid;
  StreamSubscription<DatabaseEvent>? _votesSubscription;
  StreamSubscription<DatabaseEvent>? _questionsSubscription;
  StreamSubscription<DatabaseEvent>? _currentQuestionSubscription;
  bool _isDisposed = false;
  Map<String, String> playerUidToDisplayName = {};

  @override
  void initState() {
    super.initState();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Initialize player scores
    for (var player in widget.players) {
      playerScores[player] = 0;
    }

    // Initialize with empty questions, will be populated from Firebase
    shuffledQuestions = [];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // Check if the game state has been reset
    _checkGameState();

    // Listen to room changes for synchronized questions and votes
    _listenToRoomChanges();

    // Fetch player display names
    _fetchPlayerDisplayNames();

    // Debug information
    print('Initialized SimultaneousGameScreen with players: ${widget.players}');
    print('Current user UID: $currentUserUid');
  }

  Future<void> _checkGameState() async {
    try {
      final roomRef = FirebaseDatabase.instance.ref('rooms/${widget.roomId}');
      final snapshot = await roomRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // If the game state has been reset, navigate back to GameRoomScreen
        if (data['gameStarted'] == false || data['selectedCategory'] == null) {
          print('Game state has been reset, navigating back to GameRoomScreen');

          // Use a small delay to ensure the navigation happens after the screen is built
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GameRoomScreen(roomId: widget.roomId),
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      print('Error checking game state: $e');
    }
  }

  void _listenToRoomChanges() {
    final roomRef = FirebaseDatabase.instance.ref('rooms/${widget.roomId}');

    // Listen to shuffled questions
    _questionsSubscription = roomRef
        .child('shuffledQuestions')
        .onValue
        .listen(
          (event) {
            if (_isDisposed) return;

            try {
              if (event.snapshot.value != null) {
                final data = event.snapshot.value as List<dynamic>;
                setState(() {
                  shuffledQuestions = data.map((e) => e.toString()).toList();

                  // Initialize votes for current question if we have questions
                  if (shuffledQuestions.isNotEmpty) {
                    String currentQuestion =
                        shuffledQuestions[currentQuestionIndex];
                    questionVotes[currentQuestion] = [];
                    playerVotes[currentQuestion] = {};
                  }
                });
              }
            } catch (e) {
              print('Error in questions listener: $e');
            }
          },
          onError: (error) {
            print('Error in questions listener: $error');
          },
        );

    // Listen to current question changes
    _currentQuestionSubscription = roomRef
        .child('currentQuestion')
        .onValue
        .listen(
          (event) {
            if (_isDisposed) return;

            try {
              if (event.snapshot.value != null) {
                final data = event.snapshot.value as Map<dynamic, dynamic>;
                setState(() {
                  currentQuestionIndex = data['index'] as int;
                  showingResults = data['showingResults'] as bool? ?? false;

                  // Only reset votes for new question, not when showing results
                  if (shuffledQuestions.isNotEmpty && !showingResults) {
                    String currentQuestion =
                        shuffledQuestions[currentQuestionIndex];
                    questionVotes[currentQuestion] = [];
                    playerVotes[currentQuestion] = {};
                  }
                });
              }
            } catch (e) {
              print('Error in current question listener: $e');
            }
          },
          onError: (error) {
            print('Error in current question listener: $error');
          },
        );

    // Listen to votes
    _votesSubscription = roomRef
        .child('votes')
        .onValue
        .listen(
          (event) {
            if (_isDisposed) return;

            try {
              if (event.snapshot.value != null) {
                final data = event.snapshot.value as Map<dynamic, dynamic>;

                // Store the current votes before updating state
                Map<String, String> currentVotes = {};
                data.forEach((key, value) {
                  currentVotes[key.toString()] = value.toString();
                });

                // Debug information
                print('Current votes from Firebase: $currentVotes');

                setState(() {
                  if (shuffledQuestions.isNotEmpty) {
                    String currentQuestion =
                        shuffledQuestions[currentQuestionIndex];

                    // Update player votes with the current votes from Firebase
                    playerVotes[currentQuestion] = currentVotes;

                    // Debug information
                    print(
                      'Player votes for current question: ${playerVotes[currentQuestion]}',
                    );
                    print(
                      'Number of votes: ${currentVotes.length}, Number of players: ${widget.players.length}',
                    );

                    // Check if all players have voted
                    if (currentVotes.length == widget.players.length) {
                      // Update player scores for this question
                      Map<String, int> voteCount = {};
                      for (var player in widget.players) {
                        voteCount[player] = 0;
                      }

                      currentVotes.forEach((_, votedPlayer) {
                        voteCount[votedPlayer] =
                            (voteCount[votedPlayer] ?? 0) + 1;
                      });

                      // Update total scores
                      voteCount.forEach((player, votes) {
                        playerScores[player] =
                            (playerScores[player] ?? 0) + votes;
                      });

                      // Update Firebase to show results
                      FirebaseDatabase.instance
                          .ref('rooms/${widget.roomId}/currentQuestion')
                          .update({
                            'showingResults': true,
                            'resultsTimestamp': ServerValue.timestamp,
                          });
                    }
                  }
                });
              } else {
                // Votes were cleared (new question)
                setState(() {
                  if (shuffledQuestions.isNotEmpty) {
                    String currentQuestion =
                        shuffledQuestions[currentQuestionIndex];
                    playerVotes[currentQuestion] = {};
                    showingResults = false;
                  }
                });
              }
            } catch (e) {
              print('Error in votes listener: $e');
            }
          },
          onError: (error) {
            print('Error in votes listener: $error');
          },
        );
  }

  void voteForPlayer(String votedPlayer) {
    if (showingResults) return;

    String currentQuestion = shuffledQuestions[currentQuestionIndex];

    // Update Firebase with the vote
    FirebaseDatabase.instance
        .ref('rooms/${widget.roomId}/votes/${widget.currentUserUid}')
        .set(votedPlayer)
        .then((_) {
          print(
            "Vote saved successfully: ${widget.currentUserUid} voted for $votedPlayer",
          );

          // Update lastActive timestamp
          FirebaseDatabase.instance.ref('rooms/${widget.roomId}').update({
            'lastActive': ServerValue.timestamp,
          });

          // Update local state
          setState(() {
            if (playerVotes[currentQuestion] == null) {
              playerVotes[currentQuestion] = {};
            }
            playerVotes[currentQuestion]![widget.currentUserUid] = votedPlayer;

            // Debug information
            print(
              'Local state updated with vote: ${widget.currentUserUid} -> $votedPlayer',
            );
            print('Current player votes: ${playerVotes[currentQuestion]}');
            print(
              'Number of votes: ${playerVotes[currentQuestion]!.length}, Number of players: ${widget.players.length}',
            );

            // Check if all players have voted
            if (playerVotes[currentQuestion]?.length == widget.players.length) {
              // Update Firebase to show results
              FirebaseDatabase.instance
                  .ref('rooms/${widget.roomId}/currentQuestion')
                  .update({
                    'showingResults': true,
                    'resultsTimestamp': ServerValue.timestamp,
                  });
            }
          });
        })
        .catchError((error) {
          print("Error saving vote: $error");
        });
  }

  void nextQuestion() {
    if (!showingResults) return;

    // Reset animation
    _animationController.reset();

    if (currentQuestionIndex < shuffledQuestions.length - 1) {
      final nextIndex = currentQuestionIndex + 1;

      // Update Firebase with next question
      FirebaseDatabase.instance
          .ref('rooms/${widget.roomId}/currentQuestion')
          .set({'index': nextIndex, 'showingResults': false});

      // Update lastActive timestamp
      FirebaseDatabase.instance.ref('rooms/${widget.roomId}').update({
        'lastActive': ServerValue.timestamp,
      });

      // Clear votes for the new question - use remove() instead of set(null)
      FirebaseDatabase.instance.ref('rooms/${widget.roomId}/votes').remove();

      // Start animation
      _animationController.forward();
    } else {
      // Game over, show final results
      // Use pushReplacement to replace the current screen with ResultsScreen
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => ResultsScreen(
                players: widget.players,
                playerScores: playerScores,
                categoryName: widget.categoryName,
                roomId: widget.roomId,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  void _fetchPlayerDisplayNames() {
    final roomRef = FirebaseDatabase.instance.ref(
      'rooms/${widget.roomId}/players',
    );
    roomRef.onValue.listen((event) {
      if (_isDisposed) return;

      try {
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;

          // Clear the map before updating
          playerUidToDisplayName.clear();

          // Update the map with UID to display name mappings
          data.forEach((key, value) {
            playerUidToDisplayName[key.toString()] = value.toString();
          });

          print('Player UID to display name mapping: $playerUidToDisplayName');
        }
      } catch (e) {
        print('Error fetching player display names: $e');
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _votesSubscription?.cancel();
    _questionsSubscription?.cancel();
    _currentQuestionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shuffledQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
          backgroundColor: widget.categoryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: widget.categoryColor),
              SizedBox(height: 20),
              Text('Loading questions...'),
            ],
          ),
        ),
      );
    }

    String currentQuestion = shuffledQuestions[currentQuestionIndex];
    bool hasVoted =
        playerVotes[currentQuestion]?.containsKey(widget.currentUserUid) ??
        false;

    // Debug information
    print('Current question: $currentQuestion');
    print('Question index: $currentQuestionIndex');
    print('Showing results: $showingResults');
    print('Has voted: $hasVoted');
    print('Player votes: ${playerVotes[currentQuestion]}');
    print('Player scores: $playerScores');
    print('Players: ${widget.players}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: widget.categoryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Question counter
            Text(
              'Question ${currentQuestionIndex + 1}/${shuffledQuestions.length}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Question card
            FadeTransition(
              opacity: _animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(_animation),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.question_mark,
                          size: 40,
                          color: widget.categoryColor,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          currentQuestion,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            if (showingResults) ...[
              const Text(
                'Results for this question:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    String player = widget.players[index];
                    int votes = 0;
                    List<String> voters = [];

                    // Count votes and collect voter names
                    if (playerVotes[currentQuestion] != null) {
                      playerVotes[currentQuestion]!.forEach((
                        voterUid,
                        votedPlayer,
                      ) {
                        if (votedPlayer == player) {
                          votes++;

                          // Get the voter's display name from our mapping
                          String voterDisplayName =
                              playerUidToDisplayName[voterUid] ??
                              "Player_${voterUid.length > 4 ? voterUid.substring(0, 4) : voterUid}";

                          voters.add(voterDisplayName);
                        }
                      });
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              votes > 0
                                  ? widget.categoryColor
                                  : Colors.grey[300],
                          child: Text(player[0].toUpperCase()),
                        ),
                        title: Text(player),
                        subtitle:
                            voters.isNotEmpty
                                ? Text('Voted by: ${voters.join(", ")}')
                                : null,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                votes > 0
                                    ? widget.categoryColor.withOpacity(0.2)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$votes votes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  votes > 0
                                      ? widget.categoryColor
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Always show the Next Question button when results are showing
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SoundButton(
                  soundType: 'click',
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.categoryColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward),
                      SizedBox(width: 8),
                      Text(
                        'Next Question',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(
                hasVoted
                    ? 'Waiting for other players to vote...'
                    : 'Who do you think is most likely to...',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: SoundButton(
                        soundType: 'vote',
                        onPressed:
                            hasVoted
                                ? () {}
                                : () => voteForPlayer(widget.players[index]),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (widget.categoryColor).withOpacity(
                            0.8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              foregroundColor: widget.categoryColor,
                              child: Text(
                                widget.players[index][0].toUpperCase(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              widget.players[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Votes: ${playerVotes[currentQuestion]?.length ?? 0}/${widget.players.length}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
