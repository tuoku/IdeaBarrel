import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ideabarrel/ui/screens/leaderboard_screen.dart';
import 'package:ideabarrel/ui/screens/new_idea_screen.dart';
import 'package:ideabarrel/ui/screens/swipe_screen.dart';
import 'package:overlay_support/overlay_support.dart';

final routeObserver = RouteObserver<PageRoute>();
const duration = Duration(milliseconds: 300);
void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(child:  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, unselectedWidgetColor: Colors.white),
      navigatorObservers: [routeObserver],
      home: const Root(),
    ));
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with RouteAware {
  var currentPage = 0;
  Widget body = const SwipeScreen();
  final GlobalKey _fabKey = GlobalKey();
  bool _fabVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    Timer(duration, () {
      setState(() {
        _fabVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: currentPage == 0 || currentPage == 1
          ? Visibility(
              visible: _fabVisible, child: _buildFAB(context, key: _fabKey))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: currentPage == 0 || currentPage == 1
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentPage = 0;
                          body = const SwipeScreen();
                        });
                      },
                      child: Icon(
                        Icons.style,
                        size: 28,
                        color: currentPage == 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentPage = 1;
                            body = const LeaderboardScreen();
                          });
                        },
                        child: Icon(
                          Icons.emoji_events,
                          size: 28,
                          color: currentPage == 1 ? Colors.blue : Colors.grey,
                        ))
                  ],
                ),
              ),
            )
          : null,
      appBar: body.key != null
          ? AppBar(
              title: Text(body.key.toString()),
            )
          : null,
    );
  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
        elevation: 0,
        key: key,
        onPressed: () => _onFabTap(context),
        child: const Icon(Icons.add),
      );

  _onFabTap(BuildContext context) {
    // Hide the FAB on transition start
    setState(() => _fabVisible = false);

    final RenderBox fabRenderBox =
        _fabKey.currentContext?.findRenderObject() as RenderBox;
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          const NewIdeaScreen(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size?.width,
        height: size?.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }
}
