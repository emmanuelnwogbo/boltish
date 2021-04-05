import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';

import 'package:uberclone/brandcolors.dart';
import 'package:uberclone/screens/registrationpage.dart';
import 'package:uberclone/screens/mainpage.dart';
import 'package:uberclone/widgets/ProgressDialog.dart';

import 'package:uberclone/widgets/TaxiButton.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Logging you in',
      ),
    );

    final UserCredential user = (await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ));

    if (user != null) {
      // verify login
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/${user.user.uid}');
      userRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text('Sign In as a Rider',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(children: <Widget>[
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
                            title: 'LOGIN',
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

                              if (!emailController.text.contains('@')) {
                                showSnackBar(
                                    'Please enter a valid email address');
                                return;
                              }

                              if (passwordController.text.length < 8) {
                                showSnackBar('Please enter a valid password');
                                return;
                              }

                              login();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    RegistrationPage.id, (route) => false);
                              },
                              child:
                                  Text('Don\'t have an account? sign up here'))
                        ]))
                  ],
                )),
          ),
        ));
  }
}
