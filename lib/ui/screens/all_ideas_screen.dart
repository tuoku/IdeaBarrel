import 'package:flutter/material.dart';
import 'package:ideabarrel/misc/enums.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:ideabarrel/ui/screens/simple_details_screen.dart';

import '../../models/idea.dart';
import '../../models/user.dart';

class AllIdeasScreen extends StatefulWidget {
  const AllIdeasScreen({Key? key}) : super(key: key);

  @override
  State<AllIdeasScreen> createState() => _AllIdeasScreenState();
}

class Query {
  final List<Department>? depts;
  final bool? approved;
  final bool? trending;

  Query({this.depts, this.approved, this.trending});
}

class _AllIdeasScreenState extends State<AllIdeasScreen> {
  var chip1 = false;
  var chip2 = false;
  var chip3 = false;
  var chip4 = false;
  var chip5 = false;

  int sort = 1;

  List<Idea> allIdeas = [];
  List<Idea> activeIdeas = [];
  List<String> activeFilters = [];
  List<User> allUsers = [];
  Query activeQuery = Query();

  void filter(Query query) {
    activeIdeas = allIdeas
        .where((i) =>
            (query.depts == null || query.depts!.contains(i.department)) &&
            (query.approved == null || i.approved) &&
            (query.trending == null || i.trending))
        .toList();
  }

  void sortList() {
    switch (sort) {
      case 1:
        activeIdeas.sort(((a, b) => b.totalLikes.compareTo(a.totalLikes)));
        break;
      case 2:
        activeIdeas
            .sort(((a, b) => b.comments.length.compareTo(a.comments.length)));
        break;
      case 3:
        activeIdeas.sort(((a, b) => (b.score / b.totalLikes * 100)
            .compareTo((a.score / a.totalLikes * 100))));
        break;
    }
  }

  setQuery() {
    final ls = [
      chip3 ? Department.humanResources : null,
      chip4 ? Department.workplaceResources : null,
      chip5 ? Department.siteTeam : null
    ];
    List<Department> finalLs = ls.whereType<Department>().toList();

    activeQuery = Query(
        approved: chip1 == false ? null : true,
        trending: chip2 == false ? null : true,
        depts: finalLs.isNotEmpty ? finalLs : null);
  }

  @override
  void initState() {
    CosmosRepo().getAllIdeas().then((ideas) {
      CosmosRepo().getAllUsers().then((users) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ideas.sort(
            (a, b) => b.totalLikes.compareTo(a.totalLikes),
          );
          setState(() {
            allUsers = users;
            allIdeas = ideas;
            activeIdeas = ideas;
          });
        });
      });
    });
    super.initState();
  }

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
                      setState((() {
                        chip1 = e;
                        setQuery();
                        filter(activeQuery);
                        sortList();
                      }));
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
                      setState((() {
                        chip2 = e;
                        setQuery();
                        filter(activeQuery);
                        sortList();
                      }));
                    },
                    selected: chip2,
                    showCheckmark: chip2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("Human Resources"),
                    onSelected: (e) {
                      setState((() {
                        chip3 = e;
                        setQuery();
                        filter(activeQuery);
                        sortList();
                      }));
                    },
                    selected: chip3,
                    showCheckmark: chip3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("Workplace Resources"),
                    onSelected: (e) {
                      setState((() {
                        chip4 = e;
                        setQuery();
                        filter(activeQuery);
                        sortList();
                      }));
                    },
                    selected: chip4,
                    showCheckmark: chip4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FilterChip(
                    label: const Text("Site Team"),
                    onSelected: (e) {
                      setState((() {
                        chip5 = e;
                        setQuery();
                        filter(activeQuery);
                        sortList();
                      }));
                    },
                    selected: chip5,
                    showCheckmark: chip5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Sort by:"),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton(
                    value: sort,
                    items: const [
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
                    ],
                    onChanged: (int? e) {
                      setState(() {
                        sort = e ?? 1;
                        sortList();
                      });
                    })
              ],
            ),
            Expanded(
                child: activeIdeas.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: activeIdeas.length,
                        itemBuilder: ((context, index) {
                          Idea i = activeIdeas[index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SimpleDetailsScreen(
                                        idea: i, allUsers: allUsers)));
                              },
                              title: Text(i.title),
                              subtitle: Text(
                                  "${i.totalLikes} likes, ${(i.score / i.totalLikes * 100).toStringAsFixed(0)}% liked, ${i.comments.length} comments"),
                              trailing: SizedBox(
                                  width: 50,
                                  child: Row(children: [
                                    activeIdeas[index].trending
                                        ? const Icon(
                                            Icons.local_fire_department,
                                            color: Colors.red,
                                            size: 25,
                                          )
                                        : const SizedBox(),
                                    activeIdeas[index].approved
                                        ? const Icon(
                                            Icons.done,
                                            color: Colors.green,
                                            size: 25,
                                          )
                                        : const SizedBox()
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
