import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data.docs;
          final userData = FirebaseAuth.instance.currentUser;
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              docs[index].data()['text'],
              docs[index].data()['username'],
              docs[index].data()['userImage'],
              docs[index].data()['userId'] == userData.uid,
              key: ValueKey(docs[index].documentID),
            ),
          );
        });
  }
}
