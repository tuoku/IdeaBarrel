import 'package:flutter/material.dart';
import 'package:ideabarrel/ui/screens/shop_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9),
      child: ListView(children: [
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 150,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
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
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (c) => ShopScreen()));
                          },
                          icon: Icon(Icons.shopping_cart),
                          color: Colors.white,
                          iconSize: 44,
                        )
                      ]),
                ))),
        SizedBox(
          height: 15,
        ),
        Text(
          "Top innovators",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/ukko1.jpeg"),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Matti Meikäläinen",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 250,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 44, 143, 224),
                            Color.fromARGB(255, 18, 195, 226)
                          ]),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "4031",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/ukko2.jpeg"),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Maija Muikkeli",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 200,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 44, 143, 224),
                            Color.fromARGB(255, 18, 195, 226)
                          ]),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "3701",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/ukko3.jpeg"),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Teppo Teikäläinen",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 130,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 44, 143, 224),
                            Color.fromARGB(255, 18, 195, 226)
                          ]),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "2800",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Most liked ideas",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Card(
            child: ListTile(
          title: Text("Työnnettävä mikroaaltouuni"),
          subtitle: Text("442 likes"),
        )),
        Card(
            child: ListTile(
          title: Text("Limukone aulaan!!"),
          subtitle: Text("310 likes"),
        )),
        Card(
            child: ListTile(
          title: Text("Lisää parkkipaikkoja"),
          subtitle: Text("277 likes"),
        )),
      ]),
    );
  }
}
