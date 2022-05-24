import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class newMessage extends StatefulWidget {
  const newMessage({Key? key}) : super(key: key);

  @override
  State<newMessage> createState() => _newMessageState();
}

class _newMessageState extends State<newMessage> {
  var _userEnterMessage = '';
  final _controller=TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time':Timestamp.now(),
    });
    _controller.clear();
    _userEnterMessage='';
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
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}