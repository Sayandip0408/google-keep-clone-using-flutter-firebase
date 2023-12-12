import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keep_notes/screens/Help.dart';
import 'package:share_plus/share_plus.dart';

import 'AddScreen.dart';
import 'TrashScreen.dart';
import 'UpdateScreen.dart';
import 'UserScreen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Moved to Trash!'),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Container(
          height: 45,
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Google Keep",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const UserScreen()));
                  },
                child: const Icon(FluentIcons.person_16_filled),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Text("  Google Keep",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
              ),
              const Text(""),
              const Text(""),
              const Text(""),
              ListTile(
                leading: const Icon(
                  FluentIcons.lightbulb_32_regular,
                ),
                title: const Text('Notes', style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  FluentIcons.delete_16_regular,
                ),
                title: const Text('Deleted', style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const TrashScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  FluentIcons.question_circle_32_regular,
                ),
                title: const Text('Help', style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const Help()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 800,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("notes").where("author", isEqualTo: user?.email.toString()).where("trash", isEqualTo: false).snapshots(),
              builder: (context, snapshot){
                List<Column> notesWidget = [];
                if(snapshot.hasData){
                  final notesdb = snapshot.data?.docs.reversed.toList();
                  for(var q in notesdb!){
                    String _id = q["customID"];
                    String _heading = q["heading"];
                    String _content = q["content"];
                    final noteWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(15),
                          onTap: (){},
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                                  width: double.infinity,
                                  child: Text('${q['heading']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                  width: double.infinity,
                                  child: Text('${q['content']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdateScreen(noteId: _id, heading: _heading, content: _content)));
                                          },
                                          icon: const Icon(FluentIcons.edit_16_filled, color: Colors.green,),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          var col = FirebaseFirestore.instance.collection("notes");
                                          col.doc(_id).update({"trash" : true})
                                              .then((_) => ScaffoldMessenger.of(context).showSnackBar(snackBar))
                                              .catchError((error)=> debugPrint(error.toString()));
                                        },
                                        icon: const Icon(FluentIcons.delete_16_filled, color: Colors.red,),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          Share.share("$_heading : $_content");
                                        },
                                        icon: const Icon(FluentIcons.share_16_filled, color: Colors.blue,),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Theme.of(context).colorScheme.background,),
                      ],
                    );
                    notesWidget.add(noteWidget);
                  }
                }
                return ListView(
                  children: notesWidget,
                );
              }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(FluentIcons.add_12_regular),
      ),
    );
  }
}