// ignore_for_file: prefer_const_constructors
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void LogOut() async {
    // <-- yah hai Firebase ka LogOut Method
    await FirebaseAuth.instance.signOut();

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => SignInWithPhone()));
  }

  void saveUser() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageController.text.trim();
    
    int age = int.parse(ageString);
    
    nameController.clear();
    emailController.clear();
    ageController.clear();

    if (name != "" && email != ""&& age != "") {
      Map<String, dynamic> userData = {
        'name': name, 
        'email':email,
        'age':age
        };

      _firestore.collection("newusers").add(userData);
      log("User add");
    } else {
      log("please fill the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                LogOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Age"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  saveUser();
                  
                },
                child: Text("Save")),
            SizedBox(
              height: 20,
            ),

            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("newusers").
                where("age",isGreaterThanOrEqualTo: 20).orderBy("age",descending: false).
                snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              Map<String, dynamic> userMap =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                              return ListTile(
                                title: Text(userMap["name"] + "(${userMap["age"]})"),
                                subtitle: Text(userMap["email"]),
                                onTap: (() {}),
                              );
                            })),
                      );
                    } else
                      (Text("NO Data"));
                  } else {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return SizedBox();
                }))
          ],
        ),
      )),
    );
  }
}
