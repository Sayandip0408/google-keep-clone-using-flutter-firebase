import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget{
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final headingController = TextEditingController();
  final contentController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late DatabaseReference dbRef;
  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("New Note", style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  controller: headingController,
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
                  controller: contentController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Note",
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
                onTap: ()async{
                  String tempID = "";
                  await FirebaseFirestore.instance.collection("notes").add({
                    "heading" : headingController.text,
                    "content" : contentController.text,
                    "trash" : false,
                    "author" : user?.email,
                    "customID" : "",
                  }).then((DocumentReference doc){
                    tempID = doc.id;
                  }).catchError((error)=> debugPrint(error));
                  var col = FirebaseFirestore.instance.collection("notes");
                  col.doc(tempID).update({"customID" : tempID})
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
                      Icon(FluentIcons.add_16_filled),
                      Text("  Create",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}