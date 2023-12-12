import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/screens/SignupScreen.dart';

import 'HomeScreen.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passController = TextEditingController();

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
              const Text("Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                  color: Color.fromRGBO(255, 165, 2, 1.0),
                ),
              ),
              Text("Back!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text("Sign in to add your important notes and get real-time updates on all your devices",
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
              InkWell(
                splashColor: const Color.fromRGBO(236, 204, 104, 1.0),
                borderRadius: BorderRadius.circular(20),
                onTap: () async{
                  try{
                    await _auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
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
                    child: Text("Sign In",
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
                  Text("Don't have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                  TextButton(
                      onPressed: ()=> {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignupScreen()))
                      },
                      child: const Text("Sign Up",
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