import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class TrashScreen extends StatefulWidget{
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    const delete = SnackBar(
      content: Text('Permanently deleted!'),
    );
    const restore = SnackBar(
      content: Text('Note restored!'),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Trash bin", style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 800,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("notes").where("author", isEqualTo: user?.email.toString()).where("trash", isEqualTo: true).snapshots(),
              builder: (context, snapshot){
                List<Column> notesWidget = [];
                if(snapshot.hasData){
                  final notesdb = snapshot.data?.docs.reversed.toList();
                  for(var q in notesdb!){
                    String _id = q["customID"];
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: (){
                                            var col = FirebaseFirestore.instance.collection("notes");
                                            col.doc(_id).update({"trash" : false})
                                                .then((_) => ScaffoldMessenger.of(context).showSnackBar(restore))
                                                .catchError((error)=> debugPrint(error.toString()));
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(FluentIcons.archive_arrow_back_20_regular, color: Colors.green,),
                                              Text(" Put Back", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),),
                                            ],
                                          ),
                                      ),
                                      const Text(" "),
                                      ElevatedButton(
                                        onPressed: (){
                                          var col = FirebaseFirestore.instance.collection("notes");
                                          col.doc(_id).delete()
                                              .then((_) => ScaffoldMessenger.of(context).showSnackBar(delete))
                                          .catchError((error)=> debugPrint("Error"));
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(FluentIcons.delete_16_regular, color: Colors.redAccent,),
                                            Text(" Delete Forever", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700),),
                                          ],
                                        ),
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
    );
  }
}