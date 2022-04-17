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
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                fit: StackFit.expand,
                                children: [
                                  Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          ideas[index].content['imgs'][0])),
                                  Positioned(
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                              Colors.black,
                                              Colors.transparent
                                            ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter)),
                                        height: 400,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.bottomCenter,
                                      )),
                                      LayoutBuilder(
                                        
                                        builder: ((context, constraints) {
                                       return Container(
                                          width: constraints.maxWidth,
                                          padding: EdgeInsets.only(left:15,right: 10, bottom: 100),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(ideas[index].content["title"], style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          ),),
                                          SizedBox(height: 10,),
                                          Text(ideas[index].content["desc"],style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            
                                          ),
                                          maxLines: 8, overflow: TextOverflow.ellipsis,)
                                        ],
                                      ),);
                                      }))
                                      
                                ],
                              ),
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
                    bottom: 30,
                    right: 70,
                    child: OutlinedButton(
                      child: const Icon(
                        Icons.thumb_up,
                        color: Colors.green,
                        size: 40,
                      ),
                      onPressed: () {
                        engine?.currentItem?.like();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: BorderSide(width: 2.5, color: Colors.green),
                          padding: const EdgeInsets.all(15),
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
                    bottom: 30,
                    left: 70,
                    child: OutlinedButton(
                      child: const Icon(
                        Icons.thumb_down,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: () {
                        engine?.currentItem?.nope();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: BorderSide(width: 2.5, color: Colors.red),
                          padding: const EdgeInsets.all(15),
                          primary: Colors.white),
                    ),
                  )),
          ],
        )));
  }
}
