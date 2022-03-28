import 'package:flutter/material.dart';
import 'package:ideabarrel/ui/screens/idea_details_screen.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeScreen extends StatefulWidget {
  SwipeScreen({Key? key}) : super(key: key);

  final ideas = <SwipeItem>[
    SwipeItem(
      content: {
        "title": "Limukone aulaan!!",
        "asset": "limukone.jpg",
        "desc":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      },
    ),
    SwipeItem(
      content: {
        "title": "Parkkipaikkoja lisää",
        "asset": "parkkis.jpeg",
        "desc":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      },
    ),
    SwipeItem(
      content: {
        "title": "BikeBoxit kampukselle 🥰🥰🥰",
        "asset": "bikebox.jpg",
        "desc":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      },
    ),
    SwipeItem(
      content: {
        "title": "Saisko tämmösen tänne",
        "asset": "mikro.jpg",
        "desc": "Ei jaksa ravata keittiössä kokoaja"
      },
    ),
  ];

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  var currentTab = 0;
  var stackFinished = false;
  MatchEngine? engine;

  @override
  void initState() {
    engine = MatchEngine(swipeItems: widget.ideas);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        child: Center(
            child: Stack(
          children: [
            SwipeCards(
              onStackFinished: () {
                setState(() {
                  stackFinished = true;
                });
              },
              fillSpace: true,
              itemBuilder: (context, index) {
                Widget child = Material(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                              image: AssetImage(
                                  'assets/${widget.ideas[index].content["asset"]}'))),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.ideas[index].content["title"],
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.ideas[index].content["desc"],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      )
                    ],
                  ),
                ));
                return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => IdeaDetailsScreen(
                              index: index,
                              child: child,
                            ))),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 16,
                      margin: EdgeInsets.all(20),
                      child: Hero(tag: index, child: child),
                    ));
              },
              matchEngine: engine!,
            ),
            (stackFinished
                ? Positioned(
                    left: 200,
                    bottom: 20,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Image(
                        image: AssetImage("assets/arw.png"),
                      ),
                    ))
                : Positioned(
                    bottom: 25,
                    right: 70,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.green,
                        size: 50,
                      ),
                      onPressed: () {
                        engine?.currentItem?.like();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          primary: Colors.white),
                    ),
                  )),
            (stackFinished
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Text("That's all for now!",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            "Why not suggest a new idea?",
                            style: TextStyle(fontSize: 18),
                          ),
                        ]),
                  )
                : Positioned(
                    bottom: 25,
                    left: 70,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.thumb_down,
                        color: Colors.red,
                        size: 50,
                      ),
                      onPressed: () {
                        engine?.currentItem?.nope();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          primary: Colors.white),
                    ),
                  )),
          ],
        )));
  }
}
