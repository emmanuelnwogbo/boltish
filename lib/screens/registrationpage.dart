import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';

import 'package:uberclone/brandcolors.dart';
import 'package:uberclone/screens/loginpage.dart';
import 'package:uberclone/screens/mainpage.dart';

import 'package:uberclone/widgets/TaxiButton.dart';
import 'package:uberclone/widgets/ProgressDialog.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void registerUser() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Registering you...',
      ),
    );

    try {
      final UserCredential user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ));

      if (user != null) {
        DatabaseReference newUserRef = FirebaseDatabase.instance
            .reference()
            .child('users/${user.user.uid}');

        //Prepare data to be saved on users table
        Map userMap = {
          'fullname': fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        };

        newUserRef.set(userMap);

        //Take the user to the mainPage
        Navigator.pushNamedAndRemoveUntil(
            context, MainPage.id, (route) => false);
        print('done');
        print(user.user);
      }
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      if (Platform.isAndroid) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    Image(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: 50.0,
                        image: new AssetImage('images/logo.png')),
                    SizedBox(height: 40),
                    Text('Create a Rider Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(children: <Widget>[
                          TextField(
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'Full name',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Email address',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                labelText: 'Phone number',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TaxiButton(
                            title: 'REGISTER',
                            color: BrandColors.colorGreen,
                            onPressed: () async {
                              var connectivityResult =
                                  await Connectivity().checkConnectivity();
                              if (connectivityResult !=
                                      ConnectivityResult.mobile &&
                                  connectivityResult !=
                                      ConnectivityResult.wifi) {
                                showSnackBar('No internet connectivity');
                                return;
                              }

                              if (fullNameController.text.length < 3) {
                                showSnackBar('Please provide a valid fullname');
                                return;
                              }

                              if (phoneController.text.length < 10) {
                                showSnackBar(
                                    'Please provide a valid phone number');
                                return;
                              }

                              if (!emailController.text.contains('@')) {
                                showSnackBar(
                                    'Please provide a valid email address');
                                return;
                              }

                              if (passwordController.text.length < 8) {
                                showSnackBar(
                                    'password must be at least 8 characters');
                                return;
                              }

                              registerUser();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, LoginPage.id, (route) => false);
                              },
                              child:
                                  Text('Already have an account? sign in here'))
                        ]))
                  ],
                )),
          ),
        ));
  }
}
