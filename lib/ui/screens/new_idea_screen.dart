import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:ideabarrel/misc/enums.dart';
import 'package:ideabarrel/repos/storage_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_view_indicators/step_page_indicator.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../../models/idea.dart';
import '../../repos/cosmos_repo.dart';

class NewIdeaScreen extends StatefulWidget {
  const NewIdeaScreen({Key? key}) : super(key: key);

  @override
  State<NewIdeaScreen> createState() => _NewIdeaScreenState();
}

class _NewIdeaScreenState extends State<NewIdeaScreen> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  final titleController = TextEditingController();
  final descController = TextEditingController();
  Department? selectedDepartment;
  final Map<String, XFile> imgs = {};

  void setDept(Department? dept) {
    selectedDepartment = dept;
  }

  Department? getDept() {
    return selectedDepartment;
  }

  void addImg(XFile img, String url) {
    imgs[url] = img;
  }

  Map<String, XFile> getImgs() => imgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16.0),
            child: StepPageIndicator(
              stepColor: Colors.white,
              itemCount: 5,
              currentPageNotifier: _currentPageNotifier,
              size: 16,
              onPageSelected: (int index) {
                if (_currentPageNotifier.value > index) {
                  _pageController.jumpToPage(index);
                }
              },
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: PageView(
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          },
          controller: _pageController,
          children: [
            _TitlePage(
              controller: titleController,
            ),
            _DescPage(
              controller: descController,
            ),
            _DeptPage(
              callback: setDept,
            ),
            _PhotosPage(
              addImg: addImg,
              getImgs: getImgs,
            ),
            _SubmitPage(
              title: titleController,
              desc: descController,
              getDept: getDept,
              getImgs: getImgs,
            ),
          ],
        ));
  }
}

class _TitlePage extends StatefulWidget {
  _TitlePage({Key? key, required this.controller}) : super(key: key);
  TextEditingController controller;

  @override
  State<_TitlePage> createState() => __TitlePageState();
}

class __TitlePageState extends State<_TitlePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 44, 143, 224),
          Color.fromARGB(255, 18, 195, 226)
        ]),
      ),
      padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
      child: Column(
        children: [
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 0),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Text(
                "Sum your idea up in a few words",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white),
              )),
          const SizedBox(
            height: 70,
          ),
          ShowUpAnimation(
            delayStart: const Duration(milliseconds: 100),
            animationDuration: const Duration(milliseconds: 600),
            curve: Curves.easeIn,
            direction: Direction.horizontal,
            offset: -0.2,
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: "Title",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _DescPage extends StatefulWidget {
  _DescPage({Key? key, required this.controller}) : super(key: key);
  TextEditingController controller;

  @override
  State<_DescPage> createState() => __DescPageState();
}

class __DescPageState extends State<_DescPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 44, 143, 224),
          Color.fromARGB(255, 18, 195, 226)
        ]),
      ),
      padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
      child: Column(
        children: [
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 0),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Text(
                "Tell everyone more about your idea",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white),
              )),
          const SizedBox(
            height: 70,
          ),
          ShowUpAnimation(
            delayStart: const Duration(milliseconds: 100),
            animationDuration: const Duration(milliseconds: 600),
            curve: Curves.easeIn,
            direction: Direction.horizontal,
            offset: -0.2,
            child: TextField(
              controller: widget.controller,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Description",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _DeptPage extends StatefulWidget {
  _DeptPage({Key? key, required this.callback}) : super(key: key);
  Function callback;

  @override
  State<_DeptPage> createState() => __DeptPageState();
}

class __DeptPageState extends State<_DeptPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 44, 143, 224),
          Color.fromARGB(255, 18, 195, 226)
        ]),
      ),
      padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
      child: Column(
        children: [
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 0),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Text(
                "Which department might be able to make your idea come true?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white),
              )),
          const SizedBox(
            height: 70,
          ),
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 100),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: CheckboxListTile(
                tileColor: Colors.white,
                title: const Text(
                  "Workplace Resources",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Responsible for physical improvements to the workplace",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onChanged: (b) {
                  widget.callback(
                      (b != null) ? Department.workplaceResources : b);
                },
                value: false,
              )),
          const SizedBox(
            height: 40,
          ),
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 200),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: CheckboxListTile(
                tileColor: Colors.white,
                title: const Text(
                  "Human Resources",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Responsible for the well-being of people",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onChanged: (b) {
                  widget.callback((b != null) ? Department.humanResources : b);
                },
                value: false,
              )),
          const SizedBox(
            height: 40,
          ),
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 300),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: CheckboxListTile(
                tileColor: Colors.white,
                title: const Text(
                  "Site Team",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Everything else",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onChanged: (b) {
                  widget.callback((b != null) ? Department.siteTeam : b);
                },
                value: false,
              )),
        ],
      ),
    );
  }
}

class _PhotosPage extends StatefulWidget {
  _PhotosPage({Key? key, required this.addImg, required this.getImgs})
      : super(key: key);
  Function addImg;
  Function getImgs;

  @override
  State<_PhotosPage> createState() => __PhotosPageState();
}

class __PhotosPageState extends State<_PhotosPage> {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 44, 143, 224),
          Color.fromARGB(255, 18, 195, 226)
        ]),
      ),
      padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
      child: Column(
        children: [
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 0),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Text(
                "Add some photos (optional)",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white),
              )),
          const SizedBox(
            height: 70,
          ),
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 100),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: (widget.getImgs() as Map<String, XFile>)[0] != null
                  ? Image(
                      image: FileImage(File(
                          (widget.getImgs() as Map<String, XFile>)[0]?.path ??
                              "")),
                    )
                  : InkWell(
                      onTap: () async {
                        final XFile? photo = await _picker.pickImage(
                            source: ImageSource.camera, imageQuality: 75);
                        if (photo != null) {
                          StorageRepo().uploadImage(photo).then((value) {
                            setState(() {
                              widget.addImg(photo, value ?? "");
                            });
                          });
                        }
                      },
                      child: Card(
                        elevation: 10,
                        child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 40,
                            )),
                      ))),
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 100),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Card(
                elevation: 10,
                child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 40,
                    )),
              )),
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 100),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Card(
                elevation: 10,
                child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 40,
                    )),
              )),
        ],
      ),
    );
  }
}

class _SubmitPage extends StatefulWidget {
  _SubmitPage(
      {Key? key,
      required this.getImgs,
      required this.desc,
      required this.getDept,
      required this.title})
      : super(key: key);

  TextEditingController title;
  TextEditingController desc;
  Function getDept;
  Function getImgs;

  @override
  State<_SubmitPage> createState() => __SubmitPageState();
}

class __SubmitPageState extends State<_SubmitPage> {
  ConfettiController cc = ConfettiController();
  Widget _btnChild =
      const Text("Submit", style: TextStyle(color: Colors.black, fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 44, 143, 224),
            Color.fromARGB(255, 18, 195, 226)
          ]),
        ),
        padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
        child: Column(children: [
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 0),
              animationDuration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              direction: Direction.horizontal,
              offset: -0.2,
              child: const Text(
                "That's all! Ready to submit your idea?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white),
              )),
          const SizedBox(
            height: 170,
          ),
          Stack(
            children: [
              Positioned(
                bottom: 20,
                left: 55,
                child: ConfettiWidget(
                  displayTarget: false,
                  blastDirectionality: BlastDirectionality.explosive,
                  confettiController: cc,
                ),
              ),
              ShowUpAnimation(
                  delayStart: const Duration(milliseconds: 100),
                  animationDuration: const Duration(milliseconds: 600),
                  curve: Curves.easeIn,
                  direction: Direction.horizontal,
                  offset: -0.2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(140, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: _btnChild,
                    onPressed: () async {
                      setState(() {
                        _btnChild = const Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                      final i = widget.getImgs();
                      await CosmosRepo()
                          .postIdea(Idea(
                              comments: [],
                              description: widget.desc.text,
                              imgs: (i as Map<String, XFile>)
                                  .keys
                                  .toList(),
                              score: 0,
                              submittedAt: DateTime.now(),
                              submitterUID: 0,
                              department: widget.getDept(),
                              title: widget.title.text))
                          .then((_) {
                        setState(() {
                          _btnChild = const Text("Submitted!",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20));
                        });
                        cc.play();
                      });
                    },
                  )),
            ],
          )
        ]));
  }
}
