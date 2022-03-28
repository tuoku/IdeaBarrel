import 'package:flutter/material.dart';

class IdeaDetailsScreen extends StatefulWidget {
  IdeaDetailsScreen({Key? key, required this.child, required this.index})
      : super(key: key);

  int index;
  Widget child;
  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: widget.index,
          child: widget.child,
        ),
        Text(
          "  Comments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
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
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
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
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
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
        Positioned(
          bottom: 0,
          child: TextField(
            decoration: InputDecoration(labelText: "Write a comment"),
          ),
        )
      ],
    ));
    ;
  }
}
