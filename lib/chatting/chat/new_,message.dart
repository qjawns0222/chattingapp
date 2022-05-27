import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class newMessage extends StatefulWidget {
  const newMessage({Key? key}) : super(key: key);

  @override
  State<newMessage> createState() => _newMessageState();
}

class _newMessageState extends State<newMessage> {
  var _userEnterMessage = '';
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userData = await FirebaseFirestore.instance.collection('user').doc(
        user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user!.uid,
      'username':userData.data()!['userName'],
      'userImage':userData['picked_image']

    });
    _controller.clear();
    _userEnterMessage = '';
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: 'send a message'),
              onChanged: (e) {
                setState(() {
                  _userEnterMessage = e;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage
                .trim()
                .isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
