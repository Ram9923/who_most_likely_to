import 'package:flutter/material.dart';
import 'dart:math';
import 'package:who_most_likely_to/screens/ResultsScreen.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';

class ExternalVotingGameScreen extends StatefulWidget {
  final List<String> players;
  final List<String> questions;
  final String categoryName;
  final Color categoryColor;
  final String roomId;
  final String currentUserUid;
  final List<String> externalPeople;

  const ExternalVotingGameScreen({
    super.key,
    required this.players,
    required this.questions,
    required this.categoryName,
    required this.categoryColor,
    required this.roomId,
    required this.currentUserUid,
    required this.externalPeople,
  });

  @override
  _ExternalVotingGameScreenState createState() =>
      _ExternalVotingGameScreenState();
}

class _ExternalVotingGameScreenState extends State<ExternalVotingGameScreen>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int currentPlayerTurn = 0;
  Map<String, List<String>> questionVotes = {};
  Map<String, Map<String, String>> playerVotes = {};
  Map<String, int> playerScores = {};
  Map<String, int> externalPersonScores = {};
  bool showingResults = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<String> shuffledQuestions;

  @override
  void initState() {
    super.initState();
    // Create a random number generator
    final random = Random();
    shuffledQuestions = [...widget.questions]..shuffle(random);

    // Initialize player scores
    for (var player in widget.players) {
      playerScores[player] = 0;
    }

    // Initialize external person scores
    for (var person in widget.externalPeople) {
      externalPersonScores[person] = 0;
    }

    // Initialize votes for first question
    String firstQuestion = shuffledQuestions[currentQuestionIndex];
    questionVotes[firstQuestion] = [];
    playerVotes[firstQuestion] = {};

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _submitVote(String votedPlayer) {
    setState(() {
      // Add the vote to the current question
      String currentQuestion = shuffledQuestions[currentQuestionIndex];
      questionVotes[currentQuestion]!.add(votedPlayer);
      playerVotes[currentQuestion]![widget.players[currentPlayerTurn]] =
          votedPlayer;

      // Update scores
      playerScores[votedPlayer] = (playerScores[votedPlayer] ?? 0) + 1;

      // Move to next player or show results
      if (currentPlayerTurn < widget.players.length - 1) {
        currentPlayerTurn++;
      } else {
        showingResults = true;
        _animationController.forward();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < shuffledQuestions.length - 1) {
        currentQuestionIndex++;
        currentPlayerTurn = 0;
        showingResults = false;
        _animationController.reset();

        // Initialize votes for the new question
        String newQuestion = shuffledQuestions[currentQuestionIndex];
        questionVotes[newQuestion] = [];
        playerVotes[newQuestion] = {};
      } else {
        // Game is over, navigate to results screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultsScreen(
                  players: widget.players,
                  playerScores: playerScores,
                  categoryName: widget.categoryName,
                  roomId: widget.roomId,
                  externalPeople: widget.externalPeople,
                  externalPersonScores: externalPersonScores,
                ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentQuestion = shuffledQuestions[currentQuestionIndex];
    String currentPlayer = widget.players[currentPlayerTurn];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: widget.categoryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question card
            Card(
              elevation: 4,
              color: widget.categoryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}/${shuffledQuestions.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      currentQuestion,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Current player turn
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Current Turn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      currentPlayer,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Voting options
            Expanded(
              child:
                  showingResults ? _buildResultsView() : _buildVotingOptions(),
            ),
            SizedBox(height: 20),
            // Next question button (only visible when showing results)
            if (showingResults)
              SoundButton(
                soundType: 'click',
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  currentQuestionIndex < shuffledQuestions.length - 1
                      ? 'Next Question'
                      : 'See Final Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVotingOptions() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Who is most likely to...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Players section
                  if (widget.players.length > 1) ...[
                    Text(
                      'Players',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    ...widget.players.map((player) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: SoundButton(
                          soundType: 'click',
                          onPressed: () => _submitVote(player),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.grey.shade300,
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: widget.categoryColor
                                    .withOpacity(0.2),
                                child: Text(
                                  player[0].toUpperCase(),
                                  style: TextStyle(
                                    color: widget.categoryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  player,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],

                  // External people section
                  if (widget.externalPeople.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      'External People',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    ...widget.externalPeople.map((person) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: SoundButton(
                          soundType: 'click',
                          onPressed: () => _submitVote(person),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.purple.withOpacity(0.1),
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Colors.purple.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.purple.withOpacity(0.2),
                                child: Text(
                                  person[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  person,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    String currentQuestion = shuffledQuestions[currentQuestionIndex];
    Map<String, int> voteCounts = {};
    Map<String, List<String>> votedBy = {};

    // Count votes for each player and track who voted for whom
    for (var vote in questionVotes[currentQuestion]!) {
      voteCounts[vote] = (voteCounts[vote] ?? 0) + 1;
    }

    // Correctly track who voted for whom using the playerVotes map
    playerVotes[currentQuestion]!.forEach((voter, votedFor) {
      if (!votedBy.containsKey(votedFor)) {
        votedBy[votedFor] = [];
      }
      votedBy[votedFor]!.add(voter);
    });

    // Sort players by vote count
    List<MapEntry<String, int>> sortedVotes =
        voteCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.categoryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sortedVotes.length,
                itemBuilder: (context, index) {
                  final entry = sortedVotes[index];
                  final isPlayer = widget.players.contains(entry.key);
                  final isExternal = widget.externalPeople.contains(entry.key);
                  final voters = votedBy[entry.key] ?? [];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    isPlayer
                                        ? widget.categoryColor.withOpacity(0.2)
                                        : Colors.purple.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  entry.key[0].toUpperCase(),
                                  style: TextStyle(
                                    color:
                                        isPlayer
                                            ? widget.categoryColor
                                            : Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color: Colors.purple,
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
                                color: widget.categoryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${entry.value} vote${entry.value > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.categoryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (voters.isNotEmpty) ...[
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              'Voted by: ${voters.join(", ")}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
