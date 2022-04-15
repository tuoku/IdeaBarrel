import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
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

class PageModel {
  List<Widget> children;
  Widget title;
  PageModel({required this.children, required this.title});
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

  List<Widget> pages = [];
  int maxImgs = 3;

  TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white);

  Map<Department, bool> checkboxValues = {};

  final ImagePicker _picker = ImagePicker();

  ConfettiController cc = ConfettiController();
  Widget _btnChild =
      const Text("Submit", style: TextStyle(color: Colors.black, fontSize: 20));

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
            physics: BouncingScrollPhysics(parent: LockingPageScrollPhysics(
              onAttemptDrag: (from, to) {
                if (from == 0 && to == 1) return false;
                return true;
              },
            )),
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
            controller: _pageController,
            children: pages));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var e in Department.values) {
        checkboxValues[e] = false;
      }

      PageModel titlePage = PageModel(
          title: Text(
            "Sum your idea up in a few words",
            style: titleStyle,
          ),
          children: [
            TextField(
              onSubmitted: (value) => _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                 curve: Curves.bounceIn),
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ]);

      PageModel descPage = PageModel(
          title: Text(
            "Tell everyone more about your idea",
            style: titleStyle,
          ),
          children: [
            TextField(
              controller: descController,
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
                        });
                      },
                    ));
              }));
            })
          ]);
      PageModel photosPage = PageModel(
        title: Text(
          "Add some photos (optional)",
          style: titleStyle,
        ),
        children: List.generate(maxImgs - 1, (i) {
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
                      final XFile? photo = await _picker.pickImage(
                          source: ImageSource.camera, imageQuality: 75);
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
      setState(() {
        pages = generatePages(
            [titlePage, descPage, deptPage, photosPage, submitPage]);
      });
    });
  }
}

class LockingPageScrollPhysics extends ScrollPhysics {
  /// Requests whether a drag may occur from the page at index "from"
  /// to the page at index "to". Return true to allow, false to deny.
  final Function(int from, int to) onAttemptDrag;

  /// Creates physics for a [PageView].
  const LockingPageScrollPhysics(
      {ScrollPhysics? parent, required this.onAttemptDrag})
      : super(parent: parent);

  @override
  LockingPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LockingPageScrollPhysics(
        parent: buildParent(ancestor), onAttemptDrag: onAttemptDrag);
  }

  double _getPage(ScrollMetrics position) {
    if (position is PagePosition) return position.page ?? 0;
    return position.pixels / position.viewportDimension;
  }

  double _getPixels(ScrollMetrics position, double page) {
    if (position is PagePosition) return position.getPixelsFromPage(page);
    return page * position.viewportDimension;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.\n'
            'The physics object in question was:\n'
            '  $this\n'
            'The position object in question was:\n'
            '  $position\n');
      }
      return true;
    }());

    /*
     * Handle the hard boundaries (min and max extents)
     * (identical to ClampingScrollPhysics)
     */
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }

    bool left = value < position.pixels;

    int fromPage, toPage;
    double overScroll = 0;

    if (left) {
      fromPage = position.pixels.ceil() ~/ position.viewportDimension;
      toPage = value ~/ position.viewportDimension;

      overScroll = value - fromPage * position.viewportDimension;
      overScroll = overScroll.clamp(value - position.pixels, 0.0);
    } else {
      fromPage = (position.pixels + position.viewportDimension).floor() ~/
          position.viewportDimension;
      toPage =
          (value + position.viewportDimension) ~/ position.viewportDimension;

      overScroll = value - fromPage * position.viewportDimension;
      overScroll = overScroll.clamp(0.0, value - position.pixels);
    }

    if (fromPage != toPage && !onAttemptDrag(fromPage, toPage)) {
      return overScroll;
    } else {
      return super.applyBoundaryConditions(position, value);
    }
  }
}

class PagePosition extends ScrollPositionWithSingleContext
    implements PageMetrics {
  PagePosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    this.initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    ScrollPosition? oldPosition,
  })  : assert(viewportFraction > 0.0),
        _viewportFraction = viewportFraction,
        _pageToUseOnStartup = initialPage.toDouble(),
        super(
          physics: physics,
          context: context,
          initialPixels: null,
          keepScrollOffset: keepPage,
          oldPosition: oldPosition,
        );

  final int initialPage;
  double _pageToUseOnStartup;

  @override
  double get viewportFraction => _viewportFraction;
  double _viewportFraction;

  set viewportFraction(double value) {
    if (_viewportFraction == value) return;
    final double? oldPage = page;
    _viewportFraction = value;

    if (oldPage != null) {
      jumpTo(getPixelsFromPage(oldPage));
    }
  }

  // The amount of offset that will be added to [minScrollExtent] and subtracted
  // from [maxScrollExtent], such that every page will properly snap to the center
  // of the viewport when viewportFraction is greater than 1.
  //
  // The value is 0 if viewportFraction is less than or equal to 1, larger than 0
  // otherwise.
  double get _initialPageOffset =>
      max(0, viewportDimension * (viewportFraction - 1) / 2);

  double getPageFromPixels(double pixels, double viewportDimension) {
    final double actual = max(0.0, pixels - _initialPageOffset) /
        max(1.0, viewportDimension * viewportFraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  double getPixelsFromPage(double page) {
    return page * viewportDimension * viewportFraction + _initialPageOffset;
  }

  @override
  double? get page {
    if (hasPixels) {
      return getPageFromPixels(
          pixels.clamp(minScrollExtent, maxScrollExtent), viewportDimension);
    } else {
      return null;
    }
  }

  @override
  void saveScrollOffset() {
    PageStorage.of(context.storageContext)?.writeState(
        context.storageContext, getPageFromPixels(pixels, viewportDimension));
  }

  @override
  void restoreScrollOffset() {
    if (!hasPixels) {
      final double? value = PageStorage.of(context.storageContext)
          ?.readState(context.storageContext);
      if (value != null) _pageToUseOnStartup = value;
    }
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final double? oldViewportDimensions =
        this.hasViewportDimension ? this.viewportDimension : null;
    final bool result = super.applyViewportDimension(viewportDimension);
    final double? oldPixels = this.hasPixels ? pixels : null;
    final double page = (oldViewportDimensions == null || oldPixels == null)
        ? _pageToUseOnStartup
        : getPageFromPixels(oldPixels, oldViewportDimensions);
    final double newPixels = getPixelsFromPage(page);

    if (newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }
    return result;
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final double newMinScrollExtent = minScrollExtent + _initialPageOffset;
    return super.applyContentDimensions(
      newMinScrollExtent,
      max(newMinScrollExtent, maxScrollExtent - _initialPageOffset),
    );
  }

  @override
  PageMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? viewportFraction,
  }) {
    return PageMetrics(
      minScrollExtent: minScrollExtent ?? this.minScrollExtent,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
      pixels: pixels ?? this.pixels,
      viewportDimension: viewportDimension ?? this.viewportDimension,
      axisDirection: axisDirection ?? this.axisDirection,
      viewportFraction: viewportFraction ?? this.viewportFraction,
    );
  }
}
