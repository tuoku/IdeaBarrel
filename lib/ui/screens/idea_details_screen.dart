import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ideabarrel/repos/auth_repo.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:ideabarrel/repos/functions_repo.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../models/comment.dart';
import '../../models/user.dart';

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
      required this.ideaID,
      required this.comments,
      required this.allUsers})
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
  final List<Comment> comments;

  final List<User> allUsers;


  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  TextEditingController _commentController = TextEditingController();
  bool isSending = false;
  List<Comment> comments = [];


  @override
  void initState() {
    comments = widget.comments;
    
    super.initState();
  }

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
                                onPageChanged: (int index) {},
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
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "About",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
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
              comments.isEmpty
                  ? Center(
                      child: Text("No comments yet"),
                    )
                  : SizedBox(),
              ...List.generate(comments.length, ((index) {
                return Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://innobarrel.blob.core.windows.net/img/${comments[index].commenterUID}"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.allUsers
                                    .where((e) =>
                                        e.uuid == comments[index].commenterUID)
                                    .first
                                    .name,
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(comments[index].text)
                          ],
                        )
                      ],
                    ));
              })),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            onChanged: ((value) {
                              setState(() {});
                            }),
                            decoration: InputDecoration(
                              labelText: "Write a comment",
                            ),
                            controller: _commentController,
                            onSubmitted: (value) async {
                              final uid = await AuthRepo().getUUID() ?? "";
                              if (_commentController.text.isNotEmpty &&
                                  !isSending) {
                                setState(() {
                                  isSending = true;
                                });
                                FunctionsRepo()
                                    .addComment(_commentController.text,
                                        widget.ideaID, uid)
                                    .then((value) {
                                  if (value) {
                                    showSimpleNotification(
                                        Text("Comment added!"),
                                        background: Colors.green,
                                        slideDismissDirection:
                                            DismissDirection.horizontal);
                                    setState(() async {
                                      isSending = false;

                                      comments.add(Comment(
                                          commenterUID: uid,
                                          id: "",
                                          likes: 0,
                                          submittedAt: DateTime.now(),
                                          text: _commentController.text));
                                      _commentController.clear();
                                    });
                                  } else {
                                    showSimpleNotification(
                                        Text("Something went wrong"),
                                        subtitle:
                                            Text("Comment couldn't be posted"),
                                        background: Colors.red,
                                        slideDismissDirection:
                                            DismissDirection.horizontal);
                                    setState(() {
                                      isSending = false;
                                    });
                                  }
                                });
                              }
                            },
                          ))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          primary: _commentController.text.isEmpty
                              ? Colors.grey
                              : Colors.blue),
                      onPressed: (() async {
                        final uid = await AuthRepo().getUUID() ?? "";
                        if (_commentController.text.isNotEmpty && !isSending) {
                          setState(() {
                            isSending = true;
                          });
                          FunctionsRepo()
                              .addComment(
                                  _commentController.text, widget.ideaID, uid)
                              .then((value) {
                            if (value) {
                              showSimpleNotification(Text("Comment added!"),
                                  background: Colors.green,
                                  slideDismissDirection:
                                      DismissDirection.horizontal);

                              setState(() {
                                isSending = false;

                                comments.add(Comment(
                                    commenterUID: uid,
                                    id: "",
                                    likes: 0,
                                    submittedAt: DateTime.now(),
                                    text: _commentController.text));
                                _commentController.clear();
                              });
                            } else {
                              showSimpleNotification(
                                  Text("Something went wrong"),
                                  subtitle: Text("Comment couldn't be posted"),
                                  background: Colors.red,
                                  slideDismissDirection:
                                      DismissDirection.horizontal);
                              setState(() {
                                isSending = false;
                              });
                            }
                          });
                        }
                      }),
                      child: isSending
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Icon(Icons.send))
                ],
              ),
              
            ]),
          )
        ]));
  }
}
