import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RoomItemView extends StatelessWidget {
  const RoomItemView(this.opponentName, this.opponentImage,
      this.roomLastMessage, this.oppositeUserId, this.lastMessageTime,
      {super.key});

  final String opponentImage;
  final String opponentName;
  final String roomLastMessage;
  final Timestamp lastMessageTime;
  final String oppositeUserId;

  void _onItemClick(BuildContext context) async {
    final chatProvider = Provider.of<ChatViewModel>(context, listen: false);
    var userDoc = await FirebaseFirestore.instance
        .collection('users') // Adjust collection name if needed
        .doc(oppositeUserId)
        .get();

    chatProvider.setCurrentOppositeUser(userDoc);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, RoutesNames.chatScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = lastMessageTime.toDate();
    String formattedTime = DateFormat.jm().format(dateTime);

    return ListTile(
      onTap: () {
        _onItemClick(context);
      },
      leading: CircleAvatar(
        radius: 23,
        backgroundImage: NetworkImage(opponentImage),
      ),
      title: Text(
        opponentName,
        style: GoogleFonts.akshar(
          textStyle: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      subtitle: Text(
        roomLastMessage,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: const Color.fromARGB(255, 73, 138, 114),
            ),
        textAlign: TextAlign.left,
      ),
      trailing: Text(
        formattedTime,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: const Color.fromARGB(255, 73, 138, 114),
            ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
