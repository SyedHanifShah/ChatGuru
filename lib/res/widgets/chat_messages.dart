import 'package:chat_app/data/modal/message.dart';
import 'package:chat_app/res/widgets/message_bubble.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final chatProvider = Provider.of<ChatViewModel>(context);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('createAt', descending: true)
            .where(
                '(senderId = ${authenticatedUser.uid} AND receiverId = ${chatProvider.currentOppositeUser!.id}) OR (senderId = ${chatProvider.currentOppositeUser!.id} AND receiverId = ${authenticatedUser.uid})')
            .snapshots(),
        builder: ((ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No messages foud!"),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong..."),
            );
          }
          final loadedMessages = snapshot.data!.docs;

          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 14, left: 13, right: 13),
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index];

                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1]
                    : null;
                final currentMessageUserId = chatMessage['senderId'];
                final nextMessageUserId = nextChatMessage?['senderId'];
                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;
                if (nextUserIsSame) {
                  return MessageBubble.next(
                    message: chatMessage['content'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                } else {
                  return MessageBubble.first(
                    userImage: chatProvider.currentOppositeUser!['image_url'],
                    username: chatMessage['username'],
                    message: chatMessage['content'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                }
              });
        }));
  }
}
