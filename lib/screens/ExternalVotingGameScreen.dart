import 'package:flutter/material.dart';
import 'dart:math';
import 'package:who_most_likely_to/screens/ResultsScreen.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'package:who_most_likely_to/utils/localization_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class ExternalVotingGameScreen extends StatefulWidget {
  final List<String> players;
  final List<Map<String, String>> questions;
  final Map<String, String> categoryName;
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
  late List<Map<String, String>> shuffledQuestions;

  @override
  void initState() {
    super.initState();
    print('ExternalVotingGameScreen - initState called');
    print('Players: ${widget.players}');
    print('External People: ${widget.externalPeople}');
    print('Questions: ${widget.questions}');

    // Create a random number generator
    final random = Random();
    shuffledQuestions = [...widget.questions]..shuffle(random);
    print('Shuffled Questions: $shuffledQuestions');

    // Initialize player scores
    for (var player in widget.players) {
      playerScores[player] = 0;
    }
    print('Initialized player scores: $playerScores');

    // Initialize external person scores
    for (var person in widget.externalPeople) {
      externalPersonScores[person] = 0;
    }
    print('Initialized external person scores: $externalPersonScores');

    // Initialize votes for first question
    String firstQuestion = getLocalizedQuestion(
      context,
      shuffledQuestions[currentQuestionIndex],
    );
    questionVotes[firstQuestion] = [];
    playerVotes[firstQuestion] = {};
    print('Initialized first question: $firstQuestion');
    print('Initial questionVotes: $questionVotes');
    print('Initial playerVotes: $playerVotes');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void voteForPlayer(String votedPlayer) {
    print('voteForPlayer called with: $votedPlayer');
    print('Current player turn: $currentPlayerTurn');
    print('Current question index: $currentQuestionIndex');

    setState(() {
      String currentQuestion = getLocalizedQuestion(
        context,
        shuffledQuestions[currentQuestionIndex],
      );
      print('Current question: $currentQuestion');

      questionVotes[currentQuestion]!.add(votedPlayer);
      playerVotes[currentQuestion]![widget.players[currentPlayerTurn]] =
          votedPlayer;
      print('Updated questionVotes: $questionVotes');
      print('Updated playerVotes: $playerVotes');

      currentPlayerTurn++;
      print('Updated currentPlayerTurn: $currentPlayerTurn');

      // If all players have voted for this question
      if (currentPlayerTurn >= widget.players.length) {
        print('All players have voted for this question');
        // Show results for this question
        showingResults = true;

        // Count votes for this question
        Map<String, int> voteCount = {};
        for (var player in widget.players) {
          voteCount[player] = 0;
        }
        for (var person in widget.externalPeople) {
          voteCount[person] = 0;
        }
        print('Initialized voteCount: $voteCount');

        for (var votedPlayer in questionVotes[currentQuestion]!) {
          voteCount[votedPlayer] = (voteCount[votedPlayer] ?? 0) + 1;
        }
        print('Final voteCount: $voteCount');

        // Update total scores
        voteCount.forEach((player, votes) {
          if (widget.players.contains(player)) {
            playerScores[player] = (playerScores[player] ?? 0) + votes;
          } else {
            externalPersonScores[player] =
                (externalPersonScores[player] ?? 0) + votes;
          }
        });
        print('Updated playerScores: $playerScores');
        print('Updated externalPersonScores: $externalPersonScores');
      }
    });
  }

  void nextQuestion() {
    print('nextQuestion called');
    print('Current question index: $currentQuestionIndex');
    print('Total questions: ${shuffledQuestions.length}');

    // Reset animation
    _animationController.reset();

    setState(() {
      if (currentQuestionIndex < shuffledQuestions.length - 1) {
        currentQuestionIndex++;
        currentPlayerTurn = 0;
        showingResults = false;
        print('Moving to next question: $currentQuestionIndex');
        print('Reset currentPlayerTurn: $currentPlayerTurn');

        // Initialize votes for next question
        String nextQuestion = getLocalizedQuestion(
          context,
          shuffledQuestions[currentQuestionIndex],
        );
        questionVotes[nextQuestion] = [];
        playerVotes[nextQuestion] = {};
        print('Initialized next question: $nextQuestion');
        print('Updated questionVotes: $questionVotes');
        print('Updated playerVotes: $playerVotes');

        // Start animation
        _animationController.forward();
      } else {
        print('Game over, navigating to results screen');
        print('Final playerScores: $playerScores');
        print('Final externalPersonScores: $externalPersonScores');

        // Game over, navigate to results screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultsScreen(
                  players: widget.players,
                  playerScores: playerScores,
                  categoryName: Map<String, String>.from(widget.categoryName),
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
    String currentQuestion = getLocalizedQuestion(
      context,
      shuffledQuestions[currentQuestionIndex],
    );

    // Only get current player if not showing results and there are still players to vote
    String currentPlayer =
        showingResults || currentPlayerTurn >= widget.players.length
            ? ''
            : widget.players[currentPlayerTurn];

    return Scaffold(
      appBar: AppBar(
        title: Text(getLocalizedText(context, widget.categoryName)),
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
            // Current player turn - only show if not showing results and there are still players to vote
            if (!showingResults && currentPlayerTurn < widget.players.length)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Current Turn'.tr(),
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
                onPressed: nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  currentQuestionIndex < shuffledQuestions.length - 1
                      ? 'Next Question'.tr()
                      : 'See Final Results'.tr(),
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
              'Who is most likely to...'.tr(),
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
                      'Players'.tr(),
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
                          onPressed: () => voteForPlayer(player),
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
                    }),
                  ],

                  // External people section
                  if (widget.externalPeople.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      'External People'.tr(),
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
                          onPressed: () => voteForPlayer(person),
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
                    }),
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
    print('_buildResultsView called');
    String currentQuestion = getLocalizedQuestion(
      context,
      shuffledQuestions[currentQuestionIndex],
    );
    print('Current question in results view: $currentQuestion');

    Map<String, int> voteCounts = {};
    Map<String, List<String>> votedBy = {};

    // Initialize vote counts for all players and external people
    for (var player in widget.players) {
      voteCounts[player] = 0;
    }
    for (var person in widget.externalPeople) {
      voteCounts[person] = 0;
    }
    print('Initialized voteCounts: $voteCounts');

    // Count votes for each player and track who voted for whom
    for (var vote in questionVotes[currentQuestion]!) {
      voteCounts[vote] = (voteCounts[vote] ?? 0) + 1;
    }
    print('Updated voteCounts after counting: $voteCounts');

    // Correctly track who voted for whom using the playerVotes map
    playerVotes[currentQuestion]!.forEach((voter, votedFor) {
      if (!votedBy.containsKey(votedFor)) {
        votedBy[votedFor] = [];
      }
      votedBy[votedFor]!.add(voter);
    });
    print('Voted by map: $votedBy');

    // Sort players by vote count
    List<MapEntry<String, int>> sortedVotes =
        voteCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    print('Sorted votes: $sortedVotes');
    print('Sorted votes length: ${sortedVotes.length}');

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Results'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.categoryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  sortedVotes.isEmpty
                      ? Center(
                        child: Text(
                          'No votes recorded yet'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: sortedVotes.length,
                        itemBuilder: (context, index) {
                          if (index >= sortedVotes.length) {
                            return SizedBox.shrink(); // Return an empty widget if index is out of range
                          }

                          final entry = sortedVotes[index];
                          final isPlayer = widget.players.contains(entry.key);
                          final isExternal = widget.externalPeople.contains(
                            entry.key,
                          );
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
                                                ? widget.categoryColor
                                                    .withOpacity(0.2)
                                                : Colors.purple.withOpacity(
                                                  0.2,
                                                ),
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
                                        color: widget.categoryColor.withOpacity(
                                          0.2,
                                        ),
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
