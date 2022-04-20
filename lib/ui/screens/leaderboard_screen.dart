import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ideabarrel/repos/auth_repo.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:ideabarrel/ui/screens/all_ideas_screen.dart';
import 'package:ideabarrel/ui/screens/shop_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/idea.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Idea> ideas = [];
  int? myScore;

  @override
  void initState() {
    CosmosRepo().getAllIdeas().then((value) async {
      final uid = await AuthRepo().getUUID() ?? "";
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final score = value.where((e) => e.submitterUID == uid).fold<int>(0,
            (previousValue, element) {
          return previousValue + element.totalLikes;
        });

        value.sort(
          (a, b) => a.score.compareTo(b.score),
        );

        setState(() {
          ideas = value;
          myScore = score;
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
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/ukko1.jpeg"),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Matti Meikäläinen",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 250,
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
                    const Text(
                      "4031",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/ukko2.jpeg"),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Maija Muikkeli",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 200,
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
                    const Text(
                      "3701",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/ukko3.jpeg"),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Teppo Teikäläinen",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 130,
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
                    const Text(
                      "2800",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
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
