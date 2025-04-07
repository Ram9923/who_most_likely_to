// PlayerSetupScreen.dart

import 'package:flutter/material.dart';
import 'package:who_most_likely_to/theme.dart'; // Import your theme.dart file
import 'CategorySelectionScreen.dart';
import 'package:who_most_likely_to/widgets/sound_button.dart';
import 'package:who_most_likely_to/widgets/sound_icon_button.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  _PlayerSetupScreenState createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<String> players = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Players')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Who\'s Playing?', style: AppTheme.getTitleTextStyle(context)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: AppTheme.getTextFieldInputDecoration(context),
                    onSubmitted: (_) {
                      if (_controller.text.isNotEmpty) {
                        setState(() {
                          players.add(_controller.text);
                          _controller.clear();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SoundButton(
                  soundType: 'click',
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        players.add(_controller.text);
                        _controller.clear();
                      });
                    }
                  },
                  style: AppTheme.getElevatedButtonStyle(context),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  players.isEmpty
                      ? Center(
                        child: Text(
                          'Add at least 2 players to start',
                          style: AppTheme.getBodyTextStyle(
                            context,
                          ).copyWith(color: Colors.grey),
                        ),
                      )
                      : AnimatedList(
                        initialItemCount: players.length,
                        key: GlobalKey<AnimatedListState>(),
                        itemBuilder: (context, index, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    players[index].isNotEmpty
                                        ? players[index][0].toUpperCase()
                                        : '',
                                  ),
                                ),
                                title: Text(players[index]),
                                trailing: SoundIconButton(
                                  icon: Icons.delete,
                                  soundType: 'click',
                                  onPressed: () {
                                    setState(() {
                                      final listKey =
                                          GlobalKey<AnimatedListState>();
                                      final item = players.removeAt(index);
                                      listKey.currentState?.removeItem(
                                        index,
                                        (context, animation) => SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(-1, 0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: Card(
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                child: Text(
                                                  item.isNotEmpty
                                                      ? item[0].toUpperCase()
                                                      : '',
                                                ),
                                              ),
                                              title: Text(item),
                                            ),
                                          ),
                                        ),
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 20),
            SoundButton(
              soundType: 'click',
              onPressed:
                  players.length >= 2
                      ? () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CategorySelectionScreen(players: players),
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
                      : () {},
              style: AppTheme.getElevatedButtonStyle(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
