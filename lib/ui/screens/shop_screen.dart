import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              "Swag",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Card(
                        child: Container(
                      child: Column(children: [
                        Text(
                          "T-shirt",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          image: AssetImage("assets/tpaita.jpeg"),
                          height: 200,
                        ),
                        Text(
                          "500 points",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Redeem",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        )
                      ]),
                    )),
                    Card(
                        child: Container(
                      child: Column(children: [
                        Text(
                          "Cap",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          image: AssetImage("assets/lippis.jpeg"),
                          height: 200,
                        ),
                        Text(
                          "700 points",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Redeem",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        )
                      ]),
                    )),
                    Card(
                        child: Container(
                      child: Column(children: [
                        Text(
                          "Hoodie",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          image: AssetImage("assets/huppari.jpeg"),
                          height: 200,
                        ),
                        Text(
                          "1000 points",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Redeem",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        )
                      ]),
                    )),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              "Tickets",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Card(
                        child: Container(
                      child: Column(children: [
                        Text(
                          "Movie ticket",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          image: AssetImage("assets/lippu.jpeg"),
                          height: 120,
                        ),
                        Text(
                          "1500 points",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Redeem",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        )
                      ]),
                    )),
                    Card(
                        child: Container(
                      child: Column(children: [
                        Text(
                          "Hockey game ticket",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          image: AssetImage("assets/lippu.jpeg"),
                          height: 120,
                        ),
                        Text(
                          "2000 points",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Redeem",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        )
                      ]),
                    )),
                    Card(
                        child: Container(
                      child: Column(children: [
                        Text(
                          "Opera ticket",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Image(
                          image: AssetImage("assets/lippu.jpeg"),
                          height: 120,
                        ),
                        Text(
                          "1000 points",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Redeem",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        )
                      ]),
                    )),
                  ],
                )),
          ],
        )));
  }
}
