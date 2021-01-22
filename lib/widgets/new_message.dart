import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _typedMessage = '';

  Future<void> _sendMessage() async {
    //FocusScope.of(context).unfocus(); //Close keyboard after sending message
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _typedMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.get('name'),
      'userImage': userData.get('imageUrl'),
    });

    _controller.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // "Keyaboard" functions:
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              //--
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send message...'),
              onChanged: (value) {
                setState(() {
                  _typedMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _typedMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
