import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseseries_course/Screens/email_auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'phone_auth/sign_in_with_phone.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  void LogOut() async{                     // <-- yah hai Firebase ka LogOut Method
  await FirebaseAuth.instance.signOut();

  Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.pushReplacement(context, CupertinoPageRoute(
            builder: (context) => SignInWithPhone() 
          ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){
            LogOut();
          }, icon:Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}