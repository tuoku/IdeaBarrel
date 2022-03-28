import 'package:flutter/material.dart';
import 'package:ideabarrel/ui/screens/leaderboard_screen.dart';
import 'package:ideabarrel/ui/screens/new_idea_screen.dart';
import 'package:ideabarrel/ui/screens/swipe_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  var currentPage = 0;
  Widget body = SwipeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: currentPage == 0 || currentPage == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                  return const NewIdeaScreen();
                }));
              },
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: currentPage == 0 || currentPage == 1
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentPage = 0;
                          body = SwipeScreen();
                        });
                      },
                      child: Icon(
                        Icons.style,
                        size: 28,
                        color: currentPage == 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentPage = 1;
                            body = const LeaderboardScreen();
                          });
                        },
                        child: Icon(
                          Icons.emoji_events,
                          size: 28,
                          color: currentPage == 1 ? Colors.blue : Colors.grey,
                        ))
                  ],
                ),
              ),
            )
          : null,
      appBar: body.key != null
          ? AppBar(
              title: Text(body.key.toString()),
            )
          : null,
    );
  }
}
