import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserItem extends StatelessWidget {
  const UserItem(
      {super.key,
      required this.userName,
      required this.userImage,
      required this.onItemClick});

  final String userImage;
  final String userName;
  final void Function() onItemClick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onItemClick,
      leading: CircleAvatar(
        radius: 23,
        backgroundImage: NetworkImage(userImage),
      ),
      title: Text(
        userName,
        style: GoogleFonts.akshar(
          textStyle: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
