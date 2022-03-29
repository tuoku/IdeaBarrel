import 'package:flutter/material.dart';

class NewIdeaScreen extends StatefulWidget {
  const NewIdeaScreen({Key? key}) : super(key: key);

  @override
  State<NewIdeaScreen> createState() => _NewIdeaScreenState();
}

class _NewIdeaScreenState extends State<NewIdeaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit new idea")),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Description", fillColor: Colors.grey[500]),
                minLines: 3,
                maxLines: 11,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Add photos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: Colors.grey[200],
                    height: 100,
                    width: 100,
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 40,
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 100,
                    width: 100,
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 40,
                    ),
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 100,
                    width: 100,
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Submit")),
              )
            ],
          )),
    );
  }
}
