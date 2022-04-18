import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:ideabarrel/repos/functions_repo.dart';
import 'package:ideabarrel/ui/screens/idea_details_screen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../models/idea.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  var currentTab = 0;
  var stackFinished = false;
  MatchEngine? engine;
  List<SwipeItem> ideas = [];
  List<Idea> ideaModels = [];

  double cardWidth = 0;

  @override
  void initState() {
    CosmosRepo().getAllIdeas().then((value) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          if (kDebugMode) print("Ideas fetched: ${value.length}");
          ideaModels = value;
          setState(() {
            ideas = List.generate(value.length, (i) {
              return SwipeItem(content: {
                "title": value[i].title,
                "desc": value[i].description,
                "imgs": value[i].imgs
              },
              likeAction: () => FunctionsRepo().voteIdea(true, value[i].id),
              nopeAction: () => FunctionsRepo().voteIdea(false, value[i].id),
              );
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
                      final PageController _pc = PageController();
                      final _currentPageNotifier = ValueNotifier<int>(0);
                      return StatefulBuilder(
                        builder: (context, setState) {
                          Widget images = PageView(
                                onPageChanged: (int index) {
                                  setState(() {
                                    _currentPageNotifier.value = index;
                                  });
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _pc,
                                children: List.generate(
                                    ideas[index].content['imgs'].length, (i) {
                                  return Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          ideas[index].content['imgs'][i]));
                                }),
                              );

                              Widget title = Material(
                                type: MaterialType.transparency,
                                child: Text(
                                                ideas[index].content["title"],
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                              
                              );

                              Widget desc = Material(
                                type: MaterialType.transparency,
                                child: Text(
                                                ideas[index].content["desc"],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                                maxLines: 8,
                                                overflow: TextOverflow.ellipsis,
                                              ));

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
                                    fit: StackFit.loose,
                                    children: [
                                      Hero(child: images, tag: "images$index"),
                                      Positioned(
                                          bottom: 0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                  Colors.black,
                                                  Colors.transparent
                                                ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter)),
                                            height: 400,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.bottomCenter,
                                          )),
                                      LayoutBuilder(
                                          builder: ((context, constraints) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (timeStamp) {
                                            cardWidth = constraints.maxWidth;
                                          },
                                        );
                                        return Container(
                                          width: constraints.maxWidth,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 10, bottom: 100),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                            Hero(child: title, tag: "title$index"),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Hero(child: desc, tag: "desc$index",)
                                            ],
                                          ),
                                        );
                                      })),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          width: cardWidth,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                    stops: [
                                                  0.1,
                                                  1.0
                                                ],
                                                    colors: [
                                                  Color.fromARGB(71, 0, 0, 0),
                                                  Colors.transparent
                                                ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            width: 100,
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: CirclePageIndicator(
                                                  selectedDotColor:
                                                      Colors.white,
                                                  dotColor: Colors.grey,
                                                  itemCount: ideas[index]
                                                      .content['imgs']
                                                      .length,
                                                  currentPageNotifier:
                                                      _currentPageNotifier,
                                                ),
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                        right: 0,
                                        bottom: 330,
                                        child: SizedBox(
                                          height: 400,
                                          width: 150,
                                          child: GestureDetector(
                                            onTap: () {
                                              _pc.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  curve: Curves.easeIn);
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 330,
                                        child: SizedBox(
                                          height: 400,
                                          width: 150,
                                          child: GestureDetector(
                                            onTap: () {
                                              _pc.previousPage(
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  curve: Curves.easeIn);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                          return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (c) => IdeaDetailsScreen(
                                          pageView: images,
                                          pageViewTag: "images$index",
                                          title: title,
                                          titleTag: "title$index",
                                          initialIndex: _currentPageNotifier.value,
                                          urls: ideas[index].content['imgs'], 
                                          pageController: _pc,
                                          pageNotifier: _currentPageNotifier,
                                          titleString: ideas[index].content['title'],
                                          descTag: "desc$index",
                                          descString: ideas[index].content['desc'],
                                          ideaID: ideaModels[index].id,
                                          comments: ideaModels[index].comments,
                                          )
                                          )),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 16,
                                margin: const EdgeInsets.all(15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: child,)
                              ));
                        },
                      );
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
                          side:
                              const BorderSide(width: 2.5, color: Colors.green),
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
                          side: const BorderSide(width: 2.5, color: Colors.red),
                          padding: const EdgeInsets.all(15),
                          primary: Colors.white),
                    ),
                  )),
          ],
        )));
  }
}
