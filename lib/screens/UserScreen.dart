import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'HomeScreen.dart';
import 'LoginScreen.dart';

class UserScreen extends StatefulWidget{
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _auth = FirebaseAuth.instance;
  File ? selestedFile;
  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
              onPressed: (){
                _auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen()));
              },
              icon: const Icon(FluentIcons.arrow_exit_20_filled, color: Colors.red,),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").where("email", isEqualTo: _auth.currentUser?.email.toString()).snapshots(),
            builder: (context, snapshot){
              List<Column> usersWidget = [];
              if(snapshot.hasData){
                final userdb = snapshot.data?.docs.reversed.toList();
                for(var q in userdb!){
                  String _id = q["userID"];
                  final userWidget = Column(
                    children: [
                      Container(
                        height: 80,
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(q["image"]),
                            fit: BoxFit.fill,
                          )
                        ),
                      ),
                      const Text(""),
                      ElevatedButton(
                          onPressed: ()async{
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file  = await imagePicker.pickImage(source: ImageSource.gallery);
                            debugPrint(file?.path);
                            if(file == null) return;
                            String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                            Reference referenceRoot = FirebaseStorage.instance.ref();
                            Reference referenceDir = referenceRoot.child("profileImages");
                            Reference referenceImageToUpload = referenceDir.child(uniqueFileName);
                            try{
                              await referenceImageToUpload.putFile(File(file!.path));
                              imageUrl = await referenceImageToUpload.getDownloadURL();

                              var col = FirebaseFirestore.instance.collection("users");
                              col.doc(_id).update({
                                "image" : imageUrl,
                              })
                                  .then((_) => debugPrint("Success"))
                                  .catchError((error)=> debugPrint(error.toString()));

                            }catch(e){
                              debugPrint(e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: const SizedBox(
                            height: 45,
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FluentIcons.image_20_regular),
                                Text(" Change image"),
                              ],
                            ),
                          )
                      ),
                      const Text(""),
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Name : ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
                            Text(q["name"], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
                          ],
                        ),
                      ),
                      const Text(""),
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Email : ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
                            Text(q["email"], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
                          ],
                        ),
                      ),
                      const Text(""),
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Gender : ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
                            Text(q["gender"], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
                          ],
                        ),
                      ),
                      const Text(""),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: const SizedBox(
                            height: 45,
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FluentIcons.home_20_regular),
                                Text(" Back to Home"),
                              ],
                            ),
                          ),
                      ),
                    ],
                  );
                  usersWidget.add(userWidget);
                }
              }
              return ListView(
                children: usersWidget,
              );
            },
          ),
        ),
      ),
    );
  }
}