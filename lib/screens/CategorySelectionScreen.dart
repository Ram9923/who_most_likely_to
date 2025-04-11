// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'TurnBasedGameScreen.dart';
import 'package:who_most_likely_to/constants/game_categories.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'ExternalVotingGameScreen.dart';
import 'package:who_most_likely_to/utils/localization_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<String> players;
  final List<String>? preserveExternalPeople;

  const CategorySelectionScreen({
    super.key,
    required this.players,
    this.preserveExternalPeople,
  });

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  bool useExternalVoting = false;
  List<String> externalPeople = [];
  final TextEditingController _externalPersonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize external people list if provided
    if (widget.preserveExternalPeople != null) {
      externalPeople = List.from(widget.preserveExternalPeople!);
    }
  }

  @override
  void dispose() {
    _externalPersonController.dispose();
    super.dispose();
  }

  void _addExternalPerson() {
    if (_externalPersonController.text.trim().isNotEmpty) {
      setState(() {
        externalPeople.add(_externalPersonController.text.trim());
        _externalPersonController.clear();
      });
    }
  }

  void _removeExternalPerson(int index) {
    setState(() {
      externalPeople.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Select Category'.tr()),
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
                        'Choose a Question Set'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pick a category that matches your group\'s mood'.tr(),
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
              // External Voting Toggle
              Card(
                elevation: 4,
                child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                      Row(
                        children: [
                          Icon(Icons.people_outline, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'External Voting'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Allow players to vote for people not playing the game'.tr(),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Switch(
                        value: useExternalVoting,
                        onChanged: (value) {
                          setState(() {
                            useExternalVoting = value;
                          });
                        },
                        activeColor: Colors.purple,
                      ),
                      if (useExternalVoting) ...[
                        SizedBox(height: 10),
                        Row(
                          children: [
            Expanded(
                              child: TextField(
                                controller: _externalPersonController,
                                decoration: InputDecoration(
                                  hintText: 'Enter name of external person'.tr(),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.purple,
                              ),
                              onPressed: _addExternalPerson,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (externalPeople.isNotEmpty)
                          Text(
                            'External People:'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(height: 5),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              externalPeople.asMap().entries.map((entry) {
                                return Chip(
                                  label: Text(entry.value),
                                  deleteIcon: Icon(Icons.close, size: 18),
                                  onDeleted:
                                      () => _removeExternalPerson(entry.key),
                                  backgroundColor: Colors.purple.withOpacity(
                                    0.2,
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display category buttons
              SizedBox(
                height: 400, // Fixed height for category selector
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CategorySelector(
                      categories: categories,
                      onSelectCategory: (categoryKey) {
                        final category = categories[categoryKey]!;

                        // Navigate to appropriate screen based on external voting setting
                        if (useExternalVoting) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                  ) => ExternalVotingGameScreen(
                                    players: widget.players,
                                    questions: List<Map<String, String>>.from(
                                      (category['questions'] as List).map(
                                        (q) =>
                                            Map<String, String>.from(q as Map),
                                      ),
                                    ),
                                    categoryName: Map<String, String>.from(
                                      category['name'] as Map,
                                    ),
                                    categoryColor: category['color'],
                                    roomId: 'local_mode',
                                    currentUserUid: 'local_user',
                                    externalPeople: externalPeople,
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
                        } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                  ) => TurnBasedGameScreen(
                                    players: widget.players,
                                    questions: List<Map<String, String>>.from(
                                      (category['questions'] as List).map(
                                        (q) =>
                                            Map<String, String>.from(q as Map),
                                      ),
                                    ),
                                    categoryName: Map<String, String>.from(
                                      category['name'] as Map,
                                    ),
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
                        }
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
          'Select a Category:'.tr(),
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
                          getLocalizedCategoryName(context, category),
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
