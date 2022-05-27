import 'dart:io';

import 'package:chattingapp/add_image/add_image.dart';
import 'package:chattingapp/config/palette.dart';
import 'package:chattingapp/screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = false;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  User? logdata;
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  File? userPickedImage;

  void pickedImage(File image) {
    userPickedImage = image;
  }

  void _tryValidation() {
    final isvalid = _formKey.currentState!.validate();

    if (isvalid) {
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Add_image(pickedImage);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/red.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Welcome',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: isSignupScreen
                                    ? ' to Yummy chat!'
                                    : ' back',
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          isSignupScreen
                              ? 'Signup to continue'
                              : 'Signin to continue',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //배경
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: 180,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  height: isSignupScreen ? 280.0 : 250.0,
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: 50.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? pallette.textColor1
                                          : pallette.activeColor,
                                    ),
                                  ),
                                  if (!isSignupScreen)
                                    Container(
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'SIGNUP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignupScreen
                                              ? pallette.activeColor
                                              : pallette.textColor1,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (isSignupScreen) {
                                            showAlert(context);
                                          }
                                        },
                                        child: Icon(
                                          Icons.image,
                                          color: isSignupScreen
                                              ? pallette.activeColor
                                              : pallette.textColor1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isSignupScreen)
                                    Container(
                                      height: 2,
                                      width: 95,
                                      color: Colors.orange,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(
                              top: 20,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey('sign-user'),
                                    validator: (e) {
                                      if (e!.isEmpty || e.length < 4) {
                                        return 'Please enter at least 5 Character';
                                      }
                                      return null;
                                    },
                                    onSaved: (e) {
                                      userName = e!;
                                    },
                                    onChanged: (e) {
                                      userName = e;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        color: pallette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      hintText: 'User name',
                                      hintStyle: TextStyle(
                                        color: pallette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: ValueKey('sign-email'),
                                    validator: (e) {
                                      if (e!.isEmpty || !e.contains('@')) {
                                        return 'validation email please';
                                      }
                                      return null;
                                    },
                                    onSaved: (e) {
                                      userEmail = e!;
                                    },
                                    onChanged: (e) {
                                      userEmail = e;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail_rounded,
                                        color: pallette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      hintText: 'E-mail',
                                      hintStyle: TextStyle(
                                        color: pallette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: ValueKey('sign-password'),
                                    validator: (e) {
                                      if (e!.isEmpty || e.length < 6) {
                                        return 'please enter mored than six';
                                      }
                                      return null;
                                    },
                                    onSaved: (e) {
                                      userPassword = e!;
                                    },
                                    onChanged: (e) {
                                      userPassword = e;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: pallette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: pallette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(
                              top: 50,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey('login-email'),
                                    validator: (e) {
                                      if (e!.isEmpty || !e.contains('@')) {
                                        return 'validation email please';
                                      }
                                      return null;
                                    },
                                    onSaved: (e) {
                                      userEmail = e!;
                                    },
                                    onChanged: (e) {
                                      userEmail = e;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail_outlined,
                                        color: pallette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      hintText: 'E-mail',
                                      hintStyle: TextStyle(
                                        color: pallette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: ValueKey('login-password'),
                                    validator: (e) {
                                      if (e!.isEmpty || e.length < 6) {
                                        return 'please enter mored than six';
                                      }
                                      return null;
                                    },
                                    onSaved: (e) {
                                      userPassword = e!;
                                    },
                                    onChanged: (e) {
                                      userPassword = e;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: pallette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: pallette.textColor1,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35),
                                        ),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: pallette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              //텍스트 폼 필드
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen ? 420 : 390,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        if (isSignupScreen) {
                          _tryValidation();
                          if (userPickedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('please check your image'),
                              backgroundColor: Colors.blue,
                            ));
                            setState(() {
                              showSpinner = false;
                            });
                            return;
                          }

                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            final refImage = FirebaseStorage.instance
                                .ref()
                                .child('picked_image')
                                .child(newUser.user!.uid + '.png');
                            await refImage.putFile(userPickedImage!);
                            final url = await refImage.getDownloadURL();
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(newUser.user!.uid)
                                .set({
                              "userName": userName,
                              'email': userEmail,
                              'picked_image': url
                            });
                            if (newUser.user != null) {
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                            print('catch');
                            print(e);
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'please check your user,email and password'),
                              backgroundColor: Colors.blue,
                            ));
                          }
                        }
                        if (!isSignupScreen) {
                          _tryValidation();
                          try {
                            final newUser = await _authentication
                                .signInWithEmailAndPassword(
                                    email: userEmail, password: userPassword);

                            if (newUser.user != null) {
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("check your email and password"),
                            ));
                          }
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange,
                                Colors.red,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //전송
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen
                    ? MediaQuery.of(context).size.height - 125
                    : MediaQuery.of(context).size.height - 155,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(isSignupScreen ? 'or Signup with' : 'or Signin with'),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: pallette.googleColor,
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Google'),
                    ),
                  ],
                ),
              )
              //google
            ],
          ),
        ),
      ),
    );
  }
}
