import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:uberclone/screens/mainpage.dart';
import 'package:uberclone/screens/loginpage.dart';
import 'package:uberclone/screens/registrationpage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? const FirebaseOptions(
            appId: '1:297855924061:ios:c6de2b69b03a5be8',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '297855924061',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          )
        : const FirebaseOptions(
            appId: '1:523714368433:android:58ae2c740920571e6ee390',
            apiKey: 'AIzaSyAlZYL5RsQf7ey9Hw6CbjLfK1mpRKYQ770',
            messagingSenderId: '523714368433',
            projectId: 'uberclone-d9d2a',
            databaseURL: 'https://uberclone-d9d2a-default-rtdb.firebaseio.com',
          ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //fontFamily: 'Schyler',
        primarySwatch: Colors.blue,
      ),
      //home: RegistrationPage(),
      initialRoute: RegistrationPage.id,
      routes: {
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        MainPage.id: (context) => MainPage(),
      },
    );
  }
}
