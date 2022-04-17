import 'package:flutter/material.dart';

class IdeaDetailsScreen extends StatefulWidget {
  const IdeaDetailsScreen({Key? key, required this.pageView, required this.pageViewTag})
      : super(key: key);

  final String pageViewTag;
  final Widget pageView;
  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(children: [
          Container(height: 500,child:widget.pageView ,)
      ,
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
