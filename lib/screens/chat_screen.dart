import 'package:chat_app/res/widgets/chat_messages.dart';
import 'package:chat_app/res/widgets/new_message.dart';
import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();
    final token = await fcm.getToken();
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatViewModel>(context);
    final receiverUser = chatProvider.currentOppositeUser!.data();
    String name = receiverUser!['username'];

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          title: ListTile(
            minVerticalPadding: 10,
            leading: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(receiverUser['image_url']),
            ),
            title: Text(
              name.length > 10 ? '${name.substring(0, 10)}..' : name,
              style: GoogleFonts.akshar(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            subtitle: Text(
              "Active now",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 85, 111, 101),
                  ),
              textAlign: TextAlign.left,
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.call,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )),
      body: const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      ),
    );
  }
}
