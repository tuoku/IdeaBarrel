import 'package:flutter/material.dart';

class AllIdeasScreen extends StatefulWidget {
  AllIdeasScreen({Key? key}) : super(key: key);

  @override
  State<AllIdeasScreen> createState() => _AllIdeasScreenState();
}

class _AllIdeasScreenState extends State<AllIdeasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All ideas")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            
              Wrap(children: [
               Padding(
                 padding: EdgeInsets.all(5),
                 child: FilterChip(
                   label: Text("Approved"), onSelected: (e){}),
               ),
               Padding(
                 padding: EdgeInsets.all(5),
                 child: FilterChip(
                   label: Text("Trending"), onSelected: (e){}),
               ),
                Padding(
                 padding: EdgeInsets.all(5),
                 child: FilterChip(
                   label: Text("HR"), onSelected: (e){}),
               ),
                Padding(
                 padding: EdgeInsets.all(5),
                 child: FilterChip(
                   label: Text("WR"), onSelected: (e){}),
               ),
              
              ],),
              Row(children: [
                Text("Sort by:"),
                DropdownButton(
                  
                  items: [
                    DropdownMenuItem(child: Text("Likes"), value: 1,),
                    DropdownMenuItem(child: Text("Comments"),value: 2,),
                    DropdownMenuItem(child: Text("% liked"),value: 3,),
                  ],
                   onChanged: (dynamic e){})
              ],),
              Expanded(child: 
              ListView.builder(
                itemCount: 20,
                itemBuilder: ((context, index) {
                return Card(
                    child: ListTile(
                      title: Text("Idea #$index"),
                      subtitle: Text("140 likes, 87% liked, 3 comments"),
                      trailing: Container(
                        width: 50,
                        child:  Row(children: [
                        Icon(Icons.local_fire_department, color: Colors.red,size: 25,),
                        Icon(Icons.done, color: Colors.green,size: 25,)
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