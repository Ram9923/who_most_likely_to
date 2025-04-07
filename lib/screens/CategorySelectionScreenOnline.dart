import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'TurnBasedGameScreen.dart'; // Same screen used in local mode

class CategorySelectionScreenOnline extends StatelessWidget {
  final String roomCode;
  final bool isHost;

  const CategorySelectionScreenOnline({super.key, required this.roomCode, required this.isHost});

// Define different question categories
  final Map<String, Map<String, dynamic>> categories = const {
    'fun': {
      'name': 'Fun & Casual',
      'description': 'Lighthearted questions perfect for any group',
      'icon': Icons.sentiment_very_satisfied,
      'color': Colors.orange,
      'questions': [
        "Who's most likely to forget their keys?",
        "Who's most likely to become famous?",
        "Who's most likely to sleep through their alarm?",
        "Who's most likely to win the lottery and lose the ticket?",
        "Who's most likely to become a CEO?",
        "Who's most likely to move to another country?",
        "Who's most likely to adopt 5 pets?",
        "Who's most likely to appear on a reality TV show?",
        "Who's most likely to start their own business?",
        "Who's most likely to get lost using GPS?",
        "Who's most likely to accidentally send a text to the wrong person?",
        "Who's most likely to laugh at inappropriate moments?",
        "Who's most likely to forget an important event?",
        "Who's most likely to spend all their money on gadgets?",
        "Who's most likely to bring up a topic no one cares about?",
      ],
    },
    'adventures': {
      'name': 'Adventures & Travel',
      'description': 'For the thrill seekers and explorers',
      'icon': Icons.flight,
      'color': Colors.blue,
      'questions': [
        "Who's most likely to go skydiving?",
        "Who's most likely to travel without a plan?",
        "Who's most likely to live in another country?",
        "Who's most likely to climb a mountain?",
        "Who's most likely to swim with sharks?",
        "Who's most likely to take a spontaneous road trip?",
        "Who's most likely to go backpacking through Europe?",
        "Who's most likely to learn a new language for fun?",
        "Who's most likely to camp in the wilderness?",
        "Who's most likely to try an extreme sport?",
        "Who's most likely to go on a solo travel adventure?",
        "Who's most likely to move to a place they've never visited?",
        "Who's most likely to explore the deep sea?",
        "Who's most likely to become a travel blogger?",
        "Who's most likely to hike the longest trail in the world?",
      ],
    },
    'deep': {
      'name': 'Deep & Thoughtful',
      'description': 'More meaningful questions to spark conversation',
      'icon': Icons.psychology,
      'color': Colors.indigo,
      'questions': [
        "Who's most likely to change the world?",
        "Who's most likely to write a book about their life?",
        "Who's most likely to discover something important?",
        "Who's most likely to start a charity?",
        "Who's most likely to change careers completely?",
        "Who's most likely to follow their passion regardless of money?",
        "Who's most likely to make a sacrifice for someone else?",
        "Who's most likely to stand up for what they believe in?",
        "Who's most likely to find inner peace?",
        "Who's most likely to inspire others?",
        "Who's most likely to live without social media for a year?",
        "Who's most likely to have a hidden talent no one knows about?",
        "Who's most likely to forgive someone who doesn't deserve it?",
        "Who's most likely to pursue a cause they deeply care about?",
        "Who's most likely to never give up on their dreams?",
      ],
    },
    'silly': {
      'name': 'Silly & Random',
      'description': 'Ridiculous scenarios to make everyone laugh',
      'icon': Icons.mood,
      'color': Colors.pink,
      'questions': [
        "Who's most likely to trip on nothing?",
        "Who's most likely to laugh at the wrong moment?",
        "Who's most likely to wear mismatched socks?",
        "Who's most likely to talk to themselves?",
        "Who's most likely to dance in an elevator?",
        "Who's most likely to accidentally wear their clothes inside out?",
        "Who's most likely to get caught singing in the shower?",
        "Who's most likely to eat something that fell on the floor?",
        "Who's most likely to argue with a GPS?",
        "Who's most likely to text while walking and bump into something?",
        "Who's most likely to use silly voices when talking to animals?",
        "Who's most likely to take 50 selfies before posting one?",
        "Who's most likely to send a voice note instead of a text?",
        "Who's most likely to try to start a trend that never catches on?",
        "Who's most likely to wear pajamas to a party?",
      ],
    },
    'romance': {
      'name': 'Dating & Romance',
      'description': 'Questions about love, dating and relationships',
      'icon': Icons.favorite,
      'color': Colors.redAccent,
      'questions': [
        "Who's most likely to fall in love at first sight?",
        "Who's most likely to have a secret crush?",
        "Who's most likely to propose in public?",
        "Who's most likely to have the most interesting dating story?",
        "Who's most likely to date someone completely opposite to them?",
        "Who's most likely to flirt with a stranger?",
        "Who's most likely to have the most romantic date planned?",
        "Who's most likely to get back with their ex?",
        "Who's most likely to fall asleep during a date?",
        "Who's most likely to date someone their friends don't approve of?",
        "Who's most likely to believe in soulmates?",
        "Who's most likely to have a long-distance relationship?",
        "Who's most likely to have the most dramatic breakup?",
        "Who's most likely to send love letters?",
        "Who's most likely to get caught having a secret date?",
      ],
    },
    'dirty': {
      'name': 'Edgy & Scandalous',
      'description': 'For mature players only - more risqué questions',
      'icon': Icons.whatshot,
      'color': Colors.deepPurple,
      'questions': [
        "Who's most likely to get a risqué tattoo?",
        "Who's most likely to tell a scandalous secret?",
        "Who's most likely to streak in public?",
        "Who's most likely to have the wildest dating history?",
        "Who's most likely to have an outrageous guilty pleasure?",
        "Who's most likely to get caught doing something embarrassing?",
        "Who's most likely to have a secret admirer?",
        "Who's most likely to flirt with everyone in the room?",
        "Who's most likely to send a spicy text to the wrong person?",
        "Who's most likely to have an unusual fantasy?",
        "Who's most likely to be caught in a compromising position?",
        "Who's most likely to have the most provocative social media?",
        "Who's most likely to kiss someone in front of a crowd?",
        "Who's most likely to post a scandalous picture online?",
        "Who's most likely to start an affair?",
      ],
    },
  };

  void selectCategory(String key, BuildContext context) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomCode).update({
      'selectedCategory': key,
      'status': 'playing',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Category')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').doc(roomCode).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final roomData = snapshot.data!.data() as Map<String, dynamic>;
          final selectedKey = roomData['selectedCategory'];

          // If category selected, start the game
          if (selectedKey != null && selectedKey != '') {
            final selected = categories[selectedKey];
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => TurnBasedGameScreen(
                    players: List<String>.from(roomData['players']),
                    questions: List<String>.from(selected!['questions']),
                    categoryName: selected['name'],
                    categoryColor: selected['color'],
                  ),
                ),
              );
            });
          }

          if (!isHost) {
            return const Center(
              child: Text("Waiting for host to pick a question pack..."),
            );
          }

          // Show UI for the host to pick
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String key = categories.keys.elementAt(index);
              Map<String, dynamic> category = categories[key]!;

              return GestureDetector(
                onTap: () => selectCategory(key, context),
                child: Card(
                  elevation: 4,
                  color: category['color'].withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: category['color'], width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(category['icon'], size: 40, color: category['color']),
                        const SizedBox(height: 12),
                        Text(
                          category['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['description'],
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${category['questions'].length} questions',
                          style: TextStyle(
                            color: category['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
