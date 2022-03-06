import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController textFieldController = TextEditingController();

  String message = '';

  void getCurrentUser() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        loggedInUser = currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    print(loggedInUser!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (value) {
                        setState(() {
                          message = value;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: (message != '')
                        ? () {
                            try {
                              _firestore.collection('messages').add({
                                'text': message,
                                'sender': loggedInUser!.email,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                              textFieldController.clear();
                              setState(() {
                                message = '';
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                        : null,
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageBubble> columnWidgets = [];
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageBubble = MessageBubble(
              message: messageText,
              sender: messageSender,
              isMe: (loggedInUser!.email) == messageSender,
            );
            columnWidgets.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              children: columnWidgets,
              reverse: true,
            ),
          );
        } else {
          return Center(
            child: SpinKitDoubleBounce(
              color: Colors.lightBlueAccent,
              size: 100.0,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  late final String message;
  late final String sender;
  late final bool isMe;

  MessageBubble(
      {required this.message, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? (CrossAxisAlignment.end) : (CrossAxisAlignment.start),
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12.0,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? (BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ))
                : (BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  )),
            color: (isMe) ? (Colors.lightBlueAccent) : (Colors.redAccent),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
