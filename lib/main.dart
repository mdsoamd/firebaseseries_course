import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseseries_course/Screens/home_scrren.dart';
import 'package:flutter/material.dart';

import 'Screens/email_auth/login_screen.dart';
import 'Screens/phone_auth/sign_in_with_phone.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:(FirebaseAuth.instance.currentUser != null)?HomeScreen():
      SignInWithPhone()
    );
  }
}

