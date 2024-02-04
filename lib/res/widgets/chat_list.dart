import 'package:chat_app/res/widgets/room_item_view.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('createAt', descending: true)
            .where(
                '(senderId = ${currentUser.uid}) OR (receiverId = ${currentUser.uid})')
            .snapshots(),
        builder: ((ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Chat found!, Search and chat"),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong..."),
            );
          }

          final messages = snapshot.data!.docs;

          return FutureBuilder(
              future: chatViewModel.getUserInfo(currentUser.uid, messages),
              builder: (ctx, snp) {
                if (snp.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snp.hasData || snp.data!.isEmpty || snp.data == null) {
                  return const Center(
                    child: Text("No Chat found!, Search and chat"),
                  );
                }
                final loadMessages = snp.data!;

                return ListView.builder(
                    itemCount: loadMessages.values
                        .fold(0, (sum, messages) => sum! + messages.length),
                    itemBuilder: (ctx, index) {
                      int listIndex = 0;
                      String? userId;
                      for (final entry in loadMessages.entries) {
                        for (final messageData in entry.value) {
                          if (index == listIndex) {
                            userId = entry
                                .key; // Store the user ID for potential use later
                            return RoomItemView(
                              messageData['username'],
                              messageData['image_url'],
                              messageData['content'],
                              userId,
                              messageData['createAt'],
                            );
                          }
                          listIndex++;
                        }
                      }
                      return Container();
                    });
              });
        }),
      ),
    );
  }
}
