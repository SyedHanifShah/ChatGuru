import 'package:chat_app/res/widgets/user_item.dart';
import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  var loadedPeople;
  QueryDocumentSnapshot<Map<String, dynamic>>? searchUser;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: TextField(
              onChanged: (value) {
                if (value.trim().length >= 7) {
                  for (final user in loadedPeople) {
                    if (user['number'] == value &&
                        user['number'] != currentUser.phoneNumber) {
                      setState(() {
                        searchUser = user;
                      });
                      break;
                    } else {
                      setState(() {
                        searchUser = null;
                      });
                    }
                  }
                }
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF3F6F6),
                  prefixIcon: Image.asset(
                    'assets/images/search_icon2.png',
                    height: 25,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  border: InputBorder.none),
            )),
        leadingWidth: double.infinity,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'People',
              style: GoogleFonts.akshar(
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                loadedPeople = snapshot.data!.docs;

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No user found!"),
                  );
                }

                if (searchUser == null) {
                  return const Center(
                    child: Text("No user found!"),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong..."),
                  );
                }

                return UserItem(
                  userName: searchUser!['username'],
                  userImage: searchUser!['image_url'],
                  onItemClick: () {
                    chatProvider.setCurrentOppositeUser(searchUser!);
                    Navigator.pushNamed(context, RoutesNames.chatScreen);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
