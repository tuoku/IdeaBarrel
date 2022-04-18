import 'package:flutter/material.dart';
import 'package:ideabarrel/repos/functions_repo.dart';
import 'package:overlay_support/overlay_support.dart';

class IdeaDetailsScreen extends StatefulWidget {
  const IdeaDetailsScreen(
      {Key? key,
      required this.pageView,
      required this.pageViewTag,
      required this.title,
      required this.titleTag,
      required this.pageController,
      required this.pageNotifier,
      required this.initialIndex,
      required this.urls,
      required this.titleString,
      required this.descTag,
      required this.descString,
      required this.ideaID})
      : super(key: key);

  final String pageViewTag;
  final Widget pageView;
  final ValueNotifier<int> pageNotifier;
  final PageController pageController;
  final int initialIndex;
  final List<String> urls;

  final String titleTag;
  final Widget title;
  final String titleString;

  final String descTag;
  final String descString;

  final String ideaID;

  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  TextEditingController _commentController = TextEditingController();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
          SliverAppBar(
              stretch: true,
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 500,
              collapsedHeight: kToolbarHeight,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  stretchModes: [StretchMode.zoomBackground],
                  title: Hero(
                      child: Material(
                          type: MaterialType.transparency,
                          child: Text(widget.titleString,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      tag: widget.titleTag),
                  background: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      height: 500,
                      child: Hero(
                          child: Material(
                              type: MaterialType.transparency,
                              child: PageView(
                                onPageChanged: (int index) {
                                  setState(() {
                                    widget.pageNotifier.value = index;
                                    widget.pageController.jumpToPage(index);
                                  });
                                },
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                controller: PageController(
                                    initialPage: widget.initialIndex),
                                children:
                                    List.generate(widget.urls.length, (i) {
                                  return ShaderMask(
                                      shaderCallback: (rect) {
                                        return LinearGradient(
                                          begin: Alignment.center,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                        ).createShader(Rect.fromLTRB(
                                            0, 250, rect.width, rect.height));
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(widget.urls[i])));
                                }),
                              )),
                          tag: widget.pageViewTag)))),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Hero(
                      tag: widget.descTag,
                      child: Material(
                          child: Text(
                        widget.descString,
                        style: TextStyle(fontSize: 18),
                      )))),
              Padding(
                padding: EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Comments",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/ukko1.jpeg"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Hyvä idea!!!!!!!")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/ukko2.jpeg"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Uijuma")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/ukko3.jpeg"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("😍😍😍😍😍😍😍😍")
                ],
              ),
              
              Row(
                children: [
                  Expanded(child: 
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: 
                  TextField(
                    onChanged: ((value) {
                      setState(() {
                        
                      });
                    }),
                    decoration: InputDecoration(labelText: "Write a comment",),
                    controller: _commentController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        FunctionsRepo().addComment(value, widget.ideaID);
                      }
                    },
                  ))),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                      primary: _commentController.text.isEmpty ? Colors.grey : Colors.blue
                    ),
                      onPressed: (() {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            isSending = true;
                          });
                          FunctionsRepo()
                              .addComment(
                                  _commentController.text, widget.ideaID)
                              .then((value) {
                            if (value) {
                              showSimpleNotification(
                                Text("Comment added!"),
                                background: Colors.green,
                                slideDismissDirection: DismissDirection.horizontal
                              );
                              setState(() {
                                isSending = false;
                                _commentController.clear();
                              });
                            } else {
                              showSimpleNotification(
                                Text("Something went wrong"),
                                subtitle: Text("Comment couldn't be posted"),
                                background: Colors.red,
                                slideDismissDirection: DismissDirection.horizontal
                              );
                              setState(() {
                                isSending = false;
                              });
                            }
                          });
                        }
                      }),
                      child: isSending
                          ? Center(child: CircularProgressIndicator(color: Colors.white,))
                          : Icon(Icons.send))
                ],
              ),
              SizedBox(
                height: 500,
              ),
            ]),
          )
        ]));
  }
}
