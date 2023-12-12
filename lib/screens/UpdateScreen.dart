import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget{
  const UpdateScreen({Key? key, required this.noteId, required this.heading, required this.content}) : super(key: key);
  final noteId, heading, content;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final headingController = TextEditingController();
  final contentController = TextEditingController();
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    getNote();
  }

  void getNote() async {
    headingController.text = widget.heading;
    contentController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Editing", style: TextStyle(fontWeight: FontWeight.w700),),
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
                onTap: (){
                  var col = FirebaseFirestore.instance.collection("notes");
                  col.doc(widget.noteId).update({
                    "heading" : headingController.text,
                    "content" : contentController.text,
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
                      Icon(FluentIcons.edit_20_regular),
                      Text("  Update",
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