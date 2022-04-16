import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ideabarrel/misc/enums.dart';
import 'package:ideabarrel/misc/global_keys.dart';
import 'package:ideabarrel/repos/storage_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_view_indicators/step_page_indicator.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../../models/idea.dart';
import '../../repos/cosmos_repo.dart';

class NewIdeaScreen extends StatefulWidget {
  const NewIdeaScreen({Key? key}) : super(key: key);

  @override
  State<NewIdeaScreen> createState() => NewIdeaScreenState();
}

class PageModel {
  List<Widget> children;
  Widget title;
  PageModel({required this.children, required this.title, this.passCheck});
  Function? passCheck;
}

class NewIdeaScreenState extends State<NewIdeaScreen> {
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

  List<Widget> pages = [];
  int maxImgs = 3;

  TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white);

  Map<Department, bool> checkboxValues = {};

  final ImagePicker _picker = ImagePicker();

  ConfettiController cc = ConfettiController();
  Widget _btnChild =
      const Text("Submit", style: TextStyle(color: Colors.black, fontSize: 20));

  void updatePages(Widget toAdd) {
    setState(() {
      pages.add(toAdd);
    });
  }

  void removePage(int index) {
    setState(() {
      pages.removeAt(index);
    });
  }

  void removePageRange(int start, int end) {
    setState(() {
      pages.removeRange(start, end);
    });
  }

  FocusNode descNode = FocusNode();
  FocusNode titleNode = FocusNode();

  List<Widget> generatePages(List<PageModel> pages) {
    return List.generate(pages.length, (i) {
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
                  delayStart: Duration(milliseconds: 0),
                  animationDuration: const Duration(milliseconds: 600),
                  curve: Curves.easeIn,
                  direction: Direction.horizontal,
                  offset: -0.2,
                  child: pages[i].title,
                )
              ] +
              (List.generate(pages[i].children.length, (ii) {
                return ShowUpAnimation(
                    delayStart: Duration(milliseconds: ii * 100),
                    animationDuration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn,
                    direction: Direction.horizontal,
                    offset: -0.2,
                    child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: pages[i].children[ii]));
              })),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
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
        body: Stack(
          children: [
            PageView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                onPageChanged: (int index) {
                  setState(() {
                    _currentPageNotifier.value = index;
                  });
                },
                controller: _pageController,
                children: pages),
            Positioned(
                top: MediaQuery.of(context).size.height / 2,
                right: 0,
                child: pages.length - 1 > _currentPageNotifier.value
                    ? IconButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    : SizedBox()),
            Positioned(
                top: MediaQuery.of(context).size.height / 2,
                left: 0,
                child: _currentPageNotifier.value != 0
                    ? IconButton(
                        onPressed: () {
                          _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    : SizedBox())
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var e in Department.values) {
        checkboxValues[e] = false;
      }

      PageModel photosPage = PageModel(
        title: Text(
          "Add some photos (optional)",
          style: titleStyle,
        ),
        children: List.generate(maxImgs, (i) {
          return StatefulBuilder(builder: ((context, setState) {
            return imgs.values.toList().length > i
                ? Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 10,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image(
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          image: FileImage(File(imgs.values.toList()[i].path)),
                        )))
                : InkWell(
                    onTap: () async {
                      final XFile? photo = await showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text("Add photo"),
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          final XFile? p =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 75);
                                          Navigator.pop(context, p);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.photo_camera,
                                              size: 40,
                                            ),
                                            Text("from camera")
                                          ],
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          final XFile? p =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 75);
                                          Navigator.pop(context, p);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              size: 40,
                                            ),
                                            Text("from gallery")
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            );
                          });

                      if (photo != null) {
                        StorageRepo().uploadImage(photo).then((value) {
                          setState(() {
                            imgs[value ?? ""] = photo;
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
                    ));
          }));
        }),
      );

      PageModel submitPage = PageModel(
          title: Text(
            "That's all! Ready to submit your idea?",
            style: titleStyle,
          ),
          children: [
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
                ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(140, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  child: _btnChild,
                  onPressed: () async {
                    setState(() {
                      _btnChild = const Center(
                        child: CircularProgressIndicator(),
                      );
                    });

                    await CosmosRepo()
                        .postIdea(Idea(
                            comments: [],
                            description: descController.text,
                            imgs: imgs.keys.toList(),
                            score: 0,
                            submittedAt: DateTime.now(),
                            submitterUID: 0,
                            department: checkboxValues.entries
                                .where((element) => element.value == true)
                                .first
                                .key,
                            title: titleController.text))
                        .then((_) {
                      setState(() {
                        _btnChild = const Text("Submitted!",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20));
                      });
                      cc.play();
                    });
                  },
                ),
              ],
            )
          ]);

      PageModel deptPage = PageModel(
          title: Text(
            "Which department might be able to make your idea come true?",
            style: titleStyle,
          ),
          children: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                  children: List.generate(Department.values.length, (i) {
                return Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CheckboxListTile(
                      tileColor: Colors.white,
                      title: Text(
                        Department.values[i].name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        Department.values[i].description,
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      value: checkboxValues[Department.values[i]],
                      onChanged: (b) {
                        setState(() {
                          checkboxValues.updateAll((key, value) => false);
                          checkboxValues[Department.values[i]] = b ?? false;

                          if (checkboxValues.values.contains(true) &&
                              pages.length == 3) {
                            updatePages(generatePages([photosPage]).first);
                            updatePages(generatePages([submitPage]).first);
                          }
                          if (!checkboxValues.values.contains(true) &&
                              pages.length >= 4) {
                            removePageRange(3, pages.length);
                          }
                        });
                      },
                    ));
              }));
            })
          ]);
      PageModel descPage = PageModel(
          title: Text(
            "Tell everyone more about your idea",
            style: titleStyle,
          ),
          children: [
            TextField(
              focusNode: descNode,
              onSubmitted: (value) => _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn),
              autofocus: true,
              onChanged: (value) {
                if (value.isNotEmpty && pages.length == 2) {
                  updatePages(generatePages([deptPage]).first);
                  if (checkboxValues.containsValue(true)) {
                    updatePages(generatePages([photosPage]).first);
                    updatePages(generatePages([submitPage]).first);
                  }
                }
                if (value.isEmpty && pages.length >= 3) {
                  removePageRange(2, pages.length);
                }
              },
              controller: descController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Description*",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ]);
      PageModel titlePage = PageModel(
          title: Text(
            "Sum your idea up in a few words",
            style: titleStyle,
          ),
          children: [
            TextField(
              focusNode: titleNode,
              autofocus: true,
              onChanged: (value) {
                if (value.isNotEmpty && pages.length == 1) {
                  updatePages(generatePages([descPage]).first);
                  if (descController.text.isNotEmpty) {
                    updatePages(generatePages([deptPage]).first);
                    if (checkboxValues.containsValue(true)) {
                      updatePages(generatePages([photosPage]).first);
                      updatePages(generatePages([submitPage]).first);
                    }
                  }
                }
                if (value.isEmpty && pages.length >= 2) {
                  removePageRange(1, pages.length);
                }
              },
              onSubmitted: (value) {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
                FocusScope.of(context).requestFocus(descNode);
              },
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title*",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ]);

      setState(() {
        pages = generatePages([titlePage]);
      });
    });
  }
}
