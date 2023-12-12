import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Replies extends StatefulWidget{
  const Replies({super.key});

  @override
  State<Replies> createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Replies ", style: TextStyle(fontWeight: FontWeight.w700),),
            Icon(FluentIcons.chat_16_regular)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("helps").where("author", isEqualTo: _auth.currentUser?.email).snapshots(),
            builder: (context, snapshot){
              List<Column> repliesWidget = [];
              if(snapshot.hasData){
                final replyDB = snapshot.data?.docs.reversed.toList();
                for(var q in replyDB!){
                  final replyWidget = Column(
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
                                child: Text('Problem: ${q['title']}',
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
                                child: Text('Description: ${q['desc']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                width: double.infinity,
                                child: Text('Admin: ${q['reply']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.green
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: Theme.of(context).colorScheme.background,),
                    ],
                  );
                  repliesWidget.add(replyWidget);
                }
              }
              return ListView(
                children: repliesWidget,
              );
            },
          ),
        ),
      ),
    );
  }
}