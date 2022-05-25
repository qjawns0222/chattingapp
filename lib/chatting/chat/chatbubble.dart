import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, this.meuser, {Key? key}) : super(key: key);
  final String message;
  final bool meuser;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      mainAxisAlignment:
          meuser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: meuser?Radius.circular(12):Radius.circular(0),
              bottomRight: meuser?Radius.circular(0):Radius.circular(12),

            ),
          ),
          width: 145,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(
              color: meuser?Colors.white:Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
