import 'package:flutter/material.dart';

class AllIdeasScreen extends StatefulWidget {
  const AllIdeasScreen({Key? key}) : super(key: key);

  @override
  State<AllIdeasScreen> createState() => _AllIdeasScreenState();
}

class _AllIdeasScreenState extends State<AllIdeasScreen> {
  var chip1 = false;
  var chip2 = false;
  var chip3 = false;
  var chip4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All ideas")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("Approved"),
                    onSelected: (e) {
                      setState((() => chip1 = e));
                    },
                    selected: chip1,
                    showCheckmark: chip1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("Trending"),
                    onSelected: (e) {
                      setState((() => chip2 = e));
                    },
                    selected: chip2,
                    showCheckmark: chip2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("HR"),
                    onSelected: (e) {
                      setState((() => chip3 = e));
                    },
                    selected: chip3,
                    showCheckmark: chip3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("WR"),
                    onSelected: (e) {
                      setState((() => chip4 = e));
                    },
                    selected: chip4,
                    showCheckmark: chip4,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Sort by:"),
                DropdownButton(items: const [
                  DropdownMenuItem(
                    child: Text("Likes"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Comments"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text("% liked"),
                    value: 3,
                  ),
                ], onChanged: (dynamic e) {})
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          title: Text("Idea #$index"),
                          subtitle:
                              const Text("140 likes, 87% liked, 3 comments"),
                          trailing: SizedBox(
                              width: 50,
                              child: Row(children: const [
                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 25,
                                )
                              ])),
                        ),
                      );
                    })))
          ],
        ),
      ),
    );
  }
}
