import 'package:flutter/material.dart';
import 'package:ideabarrel/ui/screens/all_ideas_screen.dart';
import 'package:ideabarrel/ui/screens/shop_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
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
                          children: const [
                            Text(
                              "My points:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            Text(
                              "591",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
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
        TextButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (c) => AllIdeasScreen()));
        }, child: Text("View all"))
        ],),
        
        const SizedBox(
          height: 10,
        ),
        const Card(
            child: ListTile(
          title: Text("Työnnettävä mikroaaltouuni"),
          subtitle: Text("442 likes"),
        )),
        const Card(
            child: ListTile(
          title: Text("Limukone aulaan!!"),
          subtitle: Text("310 likes"),
        )),
        const Card(
            child: ListTile(
          title: Text("Lisää parkkipaikkoja"),
          subtitle: Text("277 likes"),
        )),
      ]),
    );
  }
}
