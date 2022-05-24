import 'package:chattingapp/chatting/chat/message.dart';
import 'package:chattingapp/chatting/chat/new_,message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class chatScreen extends StatefulWidget {
  const chatScreen({Key? key}) : super(key: key);

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('user data error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat screen'),
        actions: [
          IconButton(
              onPressed: () {
                _authentication.signOut();
              },
              icon: Icon(
                Icons.login,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages()),
            newMessage(),
          ],
        ),
      ),
    );
  }
}
