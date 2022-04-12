import 'package:flutter/material.dart';

class IdeaDetailsScreen extends StatefulWidget {
  const IdeaDetailsScreen({Key? key, required this.child, required this.index})
      : super(key: key);

  final int index;
  final Widget child;
  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(children: [
      Hero(
        tag: widget.index,
        child: widget.child,
      ),
      const Text(
        "  Comments",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 15,
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
      const TextField(
        decoration: InputDecoration(labelText: "Write a comment"),
      ),
    ]));
  }
}
