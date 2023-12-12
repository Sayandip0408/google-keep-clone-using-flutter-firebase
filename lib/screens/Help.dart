import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/screens/Replies.dart';

class Help extends StatefulWidget{
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final _auth = FirebaseAuth.instance;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Help & Feedback ", style: TextStyle(fontWeight: FontWeight.w700),),
            Icon(FluentIcons.question_circle_12_regular),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(""),
                SizedBox(
                  height: 80,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    controller: titleController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Title",
                      labelStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                      prefixIcon: Icon(FluentIcons.document_header_20_regular, color: Theme.of(context).colorScheme.secondary,),
                    ),
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const Text(""),
                SizedBox(
                  height: 400,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    controller: descController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Desc.",
                      labelStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                      // prefixIcon: Icon(FluentIcons.document_20_regular, color: Theme.of(context).colorScheme.secondary,),
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(""),
                InkWell(
                  splashColor: const Color.fromRGBO(230, 126, 34,1.0),
                  onTap: () async{
                    await FirebaseFirestore.instance.collection("helps").add({
                          "title" : titleController.text,
                          "desc" : descController.text,
                          "author" : _auth.currentUser?.email,
                          "reply" : "No reply yet.",
                        })
                        .then((_) => debugPrint("Success"))
                        .catchError((error)=> debugPrint(error.toString()));
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(7),
                  child: Ink(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Send  ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(FluentIcons.send_28_regular),
                      ],
                    ),
                  ),
                ),
                const Text(""),
                InkWell(
                  splashColor: const Color.fromRGBO(230, 126, 34,1.0),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Replies()));
                  },
                  borderRadius: BorderRadius.circular(7),
                  child: Ink(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("See replies  ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(FluentIcons.chat_16_regular),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}