import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ideabarrel/repos/auth_repo.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:ideabarrel/ui/screens/all_ideas_screen.dart';
import 'package:ideabarrel/ui/screens/shop_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/idea.dart';
import '../../models/user.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Idea> ideas = [];
  int? myScore;
  Map<String, int> userScores = {};
  List<User> allUsers = [];
  int topScore = 0;

  @override
  void initState() {
    CosmosRepo().getAllIdeas().then((mIdeas) async {
      final uid = await AuthRepo().getUUID() ?? "";
      final users = await CosmosRepo().getAllUsers();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Map<String, int> tempMap = {};
        for (var e in users) {
          tempMap[e.uuid] = 0;
        }
        for (var idea in mIdeas) {
          tempMap.update(
            idea.submitterUID,
            (points) => (points + idea.totalLikes).toInt(),
            ifAbsent: () => idea.totalLikes,
          );
        }


        final score = tempMap[uid];

        final ls = tempMap.values.toList();
        ls.sort(((a, b) => b.compareTo(a)));
        final ts = ls.first;


        mIdeas.sort(
          (a, b) => b.score.compareTo(a.score),
        );

        setState(() {
          ideas = mIdeas;
          myScore = score;
          userScores = tempMap;
          allUsers = users;
          topScore = ts;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(children: [
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 44, 143, 224),
                    Color.fromARGB(255, 18, 195, 226)
                  ])),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My points:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            myScore != null
                                ? Text(
                                    myScore.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Shimmer.fromColors(
                                    baseColor:
                                        Color.fromARGB(255, 202, 201, 201),
                                    highlightColor: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Color.fromARGB(
                                              255, 228, 228, 228)),
                                      height: 40,
                                      width: 100,
                                    )),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) => const ShopScreen()));
                          },
                          icon: const Icon(Icons.shopping_cart),
                          color: Colors.white,
                          iconSize: 44,
                        )
                      ]),
                ))),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Top innovators",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),

        ...List.generate(min(3, userScores.length), ((i) {
          final percentageOfMax = ( userScores.values.toList()[i] / topScore) * 100;
          return Padding(
            padding: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
          children: [
             CircleAvatar(
               backgroundColor: Colors.grey[300],
              radius: 25,
              backgroundImage: NetworkImage("https://innobarrel.blob.core.windows.net/img/${userScores.keys.toList()[i]}"),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  allUsers.firstWhere((e) => e.uuid == userScores.keys.toList()[i]).name,
                  style: TextStyle(fontSize: 18),
                ),
                
                 Row(
                  children: [
                    Container(
                      height: 20,
                      width: max(10, 250 * percentageOfMax / 100),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 44, 143, 224),
                            Color.fromARGB(255, 18, 195, 226)
                          ]),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      userScores.values.toList()[i].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                
                
              ],
            ),
          ],
        ));
        })),
        
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Most liked ideas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => const AllIdeasScreen()));
                },
                child: const Text("View all"))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ...List.generate(min(3, ideas.length), (index) {
          // ideas are sorted by score asc
          return Card(
              child: ListTile(
            title: Text(ideas[index].title),
            subtitle: Text("${ideas[index].totalLikes} likes"),
          ));
        }),
      ]),
    );
  }
}
