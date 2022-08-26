// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseseries_course/Screens/email_auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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


  File? porfilepic;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void LogOut() async {
    // <-- yah hai Firebase ka LogOut Method
    await FirebaseAuth.instance.signOut();

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => SignInWithPhone()));
  }

  void saveUser()async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String Age = ageController.text.trim();

    nameController.clear();
    emailController.clear();
    ageController.clear();

    if (name != "" && email != "" && Age != "" && porfilepic != "") {

       UploadTask uploadTask = FirebaseStorage.instance.ref().child("porfilepictures").child(Uuid().v1()).putFile(porfilepic!);      // <-- Yah hai image upload karna ka code


        StreamSubscription taskSubscription = uploadTask.snapshotEvents.listen((snapshot) {                   // <-- yah code kitna persion % image upload hua batata hai
        double percentage = snapshot.bytesTransferred/snapshot.totalBytes * 100;
        log(percentage.toString());
      });
      
      
      
      
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();      // <-- yah code sa image ka Dispaly karna ke liya Url deta hai  ( <--is Url se image show kar sakte hain )
      
    taskSubscription.cancel();
      
      Map<String, dynamic> userData = {       // <-- yah Map Main data de sakte hai jo data add karenge
        'name': name,
         'email': email,
         'age':Age,
         "porfilepic":downloadurl
         };

      _firestore.collection("users").add(userData);         // <-- yah code user ka data add karta hai


      Fluttertoast.showToast(msg: "Success",                 // <-- yah code user ko message show  karwata hai
      textColor: Color.fromARGB(255, 51, 0, 255),
      backgroundColor: Colors.grey,
      fontSize: 16.0
      );

      log("User add");
    } else {

       Fluttertoast.showToast(msg:"please fill the fields",     // <-- yah code user ko message show  karwata hai
      textColor: Colors.red,
      backgroundColor: Colors.grey,
      fontSize: 16.0
      );

      log("please fill the fields");
    }

    setState(() {
      porfilepic = null;
    });
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
            CupertinoButton(
              onPressed: (() async{
               XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                 
                if (selectedImage != null){
                 File convertedFile = File(selectedImage.path);
                 setState(() {
                   porfilepic = convertedFile;
                 });

                 Fluttertoast.showToast(msg:"Image selected",     // <-- yah code user ko message show  karwata hai
                  textColor: Colors.blue,
                  backgroundColor: Colors.white30,
                  fontSize: 16.0
                  );
                 
                  log("Image selected");
                }else{

                  Fluttertoast.showToast(msg:"No Image selected",     // <-- yah code user ko message show  karwata hai
                  textColor: Colors.red,
                  backgroundColor: Colors.grey,
                  fontSize: 16.0
                  );
                  
                  log("No Image selected");
                }
               
              }),
              padding: EdgeInsets.zero,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: (porfilepic!=null)?FileImage(porfilepic!):null,
                backgroundColor: Colors.grey,
              ),
            ),
            
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

            StreamBuilder<QuerySnapshot>(                                      // <-- yah hai data show karna code
                stream: _firestore.collection("users").snapshots(),
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
                                leading: CircleAvatar(backgroundImage: NetworkImage(userMap["porfilepic"]),),
                                title: Row(children: [
                                  Text(userMap["name"]),
                                  Text(userMap["age"])
                                ],),
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
