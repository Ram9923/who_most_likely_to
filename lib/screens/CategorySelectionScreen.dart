// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'TurnBasedGameScreen.dart';
import 'package:who_most_likely_to/constants/game_categories.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';

class CategorySelectionScreen extends StatelessWidget {
  final List<String> players;

  const CategorySelectionScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
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
                        'Choose a Question Set',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pick a category that matches your group\'s mood',
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
              // Display category buttons
              Container(
                height: 400, // Fixed height for category selector
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CategorySelector(
                      categories: categories,
                      onSelectCategory: (categoryKey) {
                        final category = categories[categoryKey]!;
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    TurnBasedGameScreen(
                                      players: players,
                                      questions: List<String>.from(
                                        category['questions'],
                                      ),
                                      categoryName: category['name'],
                                      categoryColor: category['color'],
                                    ),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
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

class CategorySelector extends StatelessWidget {
  final Map<String, Map<String, dynamic>> categories;
  final Function(String) onSelectCategory;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onSelectCategory,
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

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SoundButton(
                  soundType: 'click',
                  onPressed: () => onSelectCategory(categoryKey),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey.shade300,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade400, width: 2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(category!['icon'], color: Colors.black87),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black87,
                        size: 16,
                      ),
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
