import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String selectedOption = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hello",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Color.fromRGBO(255, 165, 2, 1.0),
                  ),
                ),
              Text("There!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text("Create an account to create your important notes and get real-time updates on all your devices",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                ),
              ),
              const Text(""),
              SizedBox(
                height: 45,
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    labelText: "Enter your Name",
                    labelStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                    prefixIcon: Icon(FluentIcons.person_20_regular, color: Theme.of(context).colorScheme.secondary,),
                  ),
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              const Text(""),
              SizedBox(
                height: 45,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    labelText: "Enter your Email",
                    labelStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                    prefixIcon: Icon(FluentIcons.mail_20_regular, color: Theme.of(context).colorScheme.secondary,),
                  ),
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              const Text(""),
              SizedBox(
                height: 45,
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  obscuringCharacter: "*",
                  controller: passController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    labelText: "Create password",
                    labelStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                    prefixIcon: Icon(FluentIcons.password_20_regular, color: Theme.of(context).colorScheme.secondary,),
                  ),
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              const Text(""),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Male', style: TextStyle(fontWeight: FontWeight.w500),),
                    leading: Radio(
                      value: "Male",
                      groupValue: selectedOption,
                      fillColor: MaterialStateProperty.all(const Color.fromRGBO(255, 165, 2, 1.0)),
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Female', style: TextStyle(fontWeight: FontWeight.w500),),
                    leading: Radio(
                      value: "Female",
                      groupValue: selectedOption,
                      fillColor: MaterialStateProperty.all(const Color.fromRGBO(255, 165, 2, 1.0)),
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Text(""),
              InkWell(
                splashColor: const Color.fromRGBO(236, 204, 104, 1.0),
                borderRadius: BorderRadius.circular(20),
                onTap: () async{
                  try{
                    UserCredential res = await _auth.createUserWithEmailAndPassword(
                        email: emailController.text, password: passController.text
                    );
                    String image = "";
                    if(selectedOption == "Male"){
                      image = "https://res.cloudinary.com/dgb69w56a/image/upload/v1700310742/avatars/t2anphjgfsesdkspvpvy.png";
                    }
                    else{
                      image = "https://res.cloudinary.com/dgb69w56a/image/upload/v1700310742/avatars/nwtt4zptsmjr3txir3ah.png";
                    }
                    String tempID = "";
                    await FirebaseFirestore.instance.collection("users").add({
                      "name" : nameController.text,
                      "email" : emailController.text,
                      "gender" : selectedOption,
                      "userID" : "",
                      "image" : image,
                    }).then((DocumentReference doc){
                      tempID = doc.id;
                    }).catchError((error)=> debugPrint(error));
                    var col = FirebaseFirestore.instance.collection("users");
                    col.doc(tempID).update({"userID" : tempID})
                        .then((_) => debugPrint("Success"))
                        .catchError((error)=> debugPrint(error.toString()));
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                  }catch(e){
                    debugPrint(e.toString());
                  }
                },
                child: Ink(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(255, 165, 2, 1.0),
                  ),
                  child: const Center(
                    child: Text("Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                  TextButton(
                      onPressed: ()=> {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()))
                      },
                      child: const Text("Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(255, 165, 2, 1.0)
                        ),
                      )
                  )
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}