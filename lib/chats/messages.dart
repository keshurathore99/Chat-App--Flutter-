import 'package:chat_app/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return ListView.builder(
                  itemBuilder: (context, index) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    return MessageBubble(
                      streamSnapshot.data.documents[index]['text'],
                      streamSnapshot.data.documents[index]['userId'] ==
                          futureSnapshot.data.uid,
                      streamSnapshot.data.documents[index]['username'],
                      streamSnapshot.data.documents[index]['userImage'],
                    );
                  },
                  itemCount: streamSnapshot.data.documents.length,
                  reverse: true,
                );
              });
      },
    );
  }
}
