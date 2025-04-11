import 'package:flutter/material.dart';
import 'dart:math';
import 'package:who_most_likely_to/screens/ResultsScreen.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'package:who_most_likely_to/utils/localization_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class TurnBasedGameScreen extends StatefulWidget {
  final List<String> players;
  final List<Map<String, String>> questions;
  final Map<String, String> categoryName;
  final Color categoryColor;

  const TurnBasedGameScreen({
    super.key,
    required this.players,
    required this.questions,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  _TurnBasedGameScreenState createState() => _TurnBasedGameScreenState();
}

class _TurnBasedGameScreenState extends State<TurnBasedGameScreen>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int currentPlayerTurn = 0;
  Map<String, List<String>> questionVotes = {};
  Map<String, Map<String, String>> playerVotes = {};
  Map<String, int> playerScores = {};
  bool showingResults = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<Map<String, String>> shuffledQuestions;

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

    // Initialize votes for first question
    String firstQuestion = getLocalizedQuestion(
      context,
      shuffledQuestions[currentQuestionIndex],
    );
    questionVotes[firstQuestion] = [];
    playerVotes[firstQuestion] = {};

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
    setState(() {
      String currentQuestion = getLocalizedQuestion(
        context,
        shuffledQuestions[currentQuestionIndex],
      );
      questionVotes[currentQuestion]!.add(votedPlayer);
      playerVotes[currentQuestion]![widget.players[currentPlayerTurn]] =
          votedPlayer;

      currentPlayerTurn++;

      // If all players have voted for this question
      if (currentPlayerTurn >= widget.players.length) {
        // Show results for this question
        showingResults = true;

        // Count votes for this question
        Map<String, int> voteCount = {};
        for (var player in widget.players) {
          voteCount[player] = 0;
        }

        for (var votedPlayer in questionVotes[currentQuestion]!) {
          voteCount[votedPlayer] = (voteCount[votedPlayer] ?? 0) + 1;
        }

        // Update total scores
        voteCount.forEach((player, votes) {
          playerScores[player] = (playerScores[player] ?? 0) + votes;
        });
      }
    });
  }

  void nextQuestion() {
    // Reset animation
    _animationController.reset();

    setState(() {
      if (currentQuestionIndex < shuffledQuestions.length - 1) {
        currentQuestionIndex++;
        currentPlayerTurn = 0;
        showingResults = false;

        // Initialize votes for next question
        String nextQuestion = getLocalizedQuestion(
          context,
          shuffledQuestions[currentQuestionIndex],
        );
        questionVotes[nextQuestion] = [];
        playerVotes[nextQuestion] = {};

        // Start animation
        _animationController.forward();
      } else {
        // Game over, show final results
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => ResultsScreen(
                  players: widget.players,
                  playerScores: playerScores,
                  categoryName: Map<String, String>.from(widget.categoryName),
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
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

    return Scaffold(
      appBar: AppBar(
        title: Text(getLocalizedText(context, widget.categoryName)),
        backgroundColor: widget.categoryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Question counter
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
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

            // If showing results for current question
            if (showingResults) ...[
              Text(
                'Results for this question:'.tr(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    final player = widget.players[index];
                    final votes =
                        questionVotes[currentQuestion]!
                            .where((v) => v == player)
                            .length;
                    final votedBy = playerVotes[currentQuestion]!.entries
                        .where((e) => e.value == player)
                        .map((e) => e.key)
                        .join(', ');

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(20 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: SoundButton(
                          soundType: 'vote',
                          onPressed:
                              showingResults
                                  ? () {}
                                  : () => voteForPlayer(player),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
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
                                votedBy.isNotEmpty
                                    ? Text('Voted by: $votedBy')
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
                        ),
                      ),
                    );
                  },
                ),
              ),
              SoundButton(
                soundType: 'click',
                onPressed: nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_forward),
                    const SizedBox(width: 8),
                    Text(
                      currentQuestionIndex < widget.questions.length - 1
                          ? 'Next Question'.tr()
                          : 'See Final Results'.tr(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Current player turn
              Text(
                '${widget.players[currentPlayerTurn]}\'s turn to vote',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Who do you think is most likely to...'.tr(),
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (widget.categoryColor).withOpacity(
                            0.8,
                          ),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => voteForPlayer(widget.players[index]),
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
                'After voting, pass the phone to the next player'.tr(),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
