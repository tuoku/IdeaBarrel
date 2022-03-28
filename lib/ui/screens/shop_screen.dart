import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Shop")),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                const Text(
                  "Swag",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Card(
                          child: Column(children: [
                            const Text(
                              "T-shirt",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image: AssetImage("assets/tpaita.jpeg"),
                              height: 200,
                            ),
                            const Text(
                              "500 points",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Redeem",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            )
                          ]),
                        ),
                        Card(
                          child: Column(children: [
                            const Text(
                              "Cap",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image: AssetImage("assets/lippis.jpeg"),
                              height: 200,
                            ),
                            const Text(
                              "700 points",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Redeem",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            )
                          ]),
                        ),
                        Card(
                          child: Column(children: [
                            const Text(
                              "Hoodie",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image: AssetImage("assets/huppari.jpeg"),
                              height: 200,
                            ),
                            const Text(
                              "1000 points",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Redeem",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            )
                          ]),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Tickets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Card(
                          child: Column(children: [
                            const Text(
                              "Movie ticket",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image: AssetImage("assets/lippu.jpeg"),
                              height: 120,
                            ),
                            const Text(
                              "1500 points",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Redeem",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            )
                          ]),
                        ),
                        Card(
                          child: Column(children: [
                            const Text(
                              "Hockey game ticket",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image: AssetImage("assets/lippu.jpeg"),
                              height: 120,
                            ),
                            const Text(
                              "2000 points",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Redeem",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            )
                          ]),
                        ),
                        Card(
                          child: Column(children: [
                            const Text(
                              "Opera ticket",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image: AssetImage("assets/lippu.jpeg"),
                              height: 120,
                            ),
                            const Text(
                              "1000 points",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Redeem",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            )
                          ]),
                        ),
                      ],
                    )),
              ],
            )));
  }
}
