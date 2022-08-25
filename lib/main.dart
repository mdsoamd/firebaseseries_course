import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseseries_course/Screens/home_scrren.dart';
import 'package:flutter/material.dart';

import 'Screens/email_auth/login_screen.dart';
import 'Screens/phone_auth/sign_in_with_phone.dart';
import 'PracticSet/practice_set.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// FirebaseFirestore _firestore = FirebaseFirestore.instance;

//  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").get();  // <-- yah hai All Users get karne ka code
//  for(var doc in snapshot.docs){
//     log(doc.data().toString());
//  }




//  DocumentSnapshot snapshot2 = await FirebaseFirestore.instance.collection("users").doc("2YlfVMEUPzeFXBZlkcdi").get();     // <-- yah hai Single user ka get karne ka code
//  log(snapshot2.data().toString());
 




// Map<String,dynamic> newUserdata ={
//       'name':'akif',
//       'email':'alif1@gamil'
// };
 

//  await _firestore.collection('users').add(newUserdata);       // <-- Yah hai data add karna ka code
//  log("New User add");



//  await _firestore.collection('users').doc("Your id here").set(newUserdata);      // <-- Yah hai doc custom id name ka sait data update karna ka code
//  log("New User add");


//  wait _firestore.collection('users').doc("Your id here").update({       // <-- Yah hai data update karna ka code
//       'email':"somad10@gmalupdate"
//  });
//  log("User updated");
 

// await _firestore.collection("users").doc("Your id here").delete();     // <-- Yah hai user ko delete karne ka code
// log("User deleted");
  

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:(FirebaseAuth.instance.currentUser != null)?HomeScreen():      // <-- Yah code Check karta hai user login hai ya nahin
      SignInWithPhone()
    );
  }
}

