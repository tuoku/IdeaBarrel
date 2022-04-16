import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:ideabarrel/ui/screens/idea_details_screen.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeScreen extends StatefulWidget {
  SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  var currentTab = 0;
  var stackFinished = false;
  MatchEngine? engine;
  List<SwipeItem> ideas = [];

  @override
  void initState() {
    CosmosRepo().getAllIdeas().then((value) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) {
          if (kDebugMode) print("Ideas fetched: ${value.length}");
          setState(() {
            ideas = List.generate(value.length, (i) {
              return SwipeItem(content: {
                "title": value[i].title,
                "desc": value[i].description,
                "imgs": value[i].imgs
              });
            });
            engine = MatchEngine(swipeItems: ideas);
          });
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
            child: Stack(
          children: [
            engine != null
                ? SwipeCards(
                    onStackFinished: () {
                      setState(() {
                        stackFinished = true;
                      });
                    },
                    fillSpace: true,
                    itemBuilder: (context, index) {
                      Widget child = Material(
                          child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image(
                                    image: NetworkImage(
                                        ideas[index].content['imgs'][0]))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ideas[index].content["title"],
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ideas[index].content["desc"],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 8,
                            )
                          ],
                        ),
                      ));
                      return GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => IdeaDetailsScreen(
                                        index: index,
                                        child: child,
                                      ))),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 16,
                            margin: const EdgeInsets.all(20),
                            child: Hero(tag: index, child: child),
                          ));
                    },
                    matchEngine: engine!,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            (stackFinished
                ? const Positioned(
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
                      child: const Icon(
                        Icons.thumb_up,
                        color: Colors.green,
                        size: 50,
                      ),
                      onPressed: () {
                        engine?.currentItem?.like();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          primary: Colors.white),
                    ),
                  )),
            (stackFinished
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                      child: const Icon(
                        Icons.thumb_down,
                        color: Colors.red,
                        size: 50,
                      ),
                      onPressed: () {
                        engine?.currentItem?.nope();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          primary: Colors.white),
                    ),
                  )),
          ],
        )));
  }
}
