import 'package:chat_app/res/widgets/chat_list.dart';
import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    // final currentUser = FirebaseAuth.instance.currentUser!;
    // final chatViewModel = Provider.of<ChatViewModel>(context);
    // contactsViewModel.askPermissions(context);
    // contactsViewModel.getContacts(currentUser.uid);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/search_icon.png'),
          onPressed: () {
            Navigator.of(context).pushNamed(RoutesNames.searchBarScreen);
          },
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_currentUser.uid)
                .snapshots(),
            builder: (ctx, snp) {
              var userData = null;

              if (snp.hasData) {
                userData = snp.data!.get('image_url');
              }

              return CircleAvatar(
                backgroundImage: NetworkImage(userData ?? ''),
                radius: 20,
              );
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        centerTitle: true,
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.background,
              ),
        ),
      ),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          child: const ChatList()),
    );
  }
}
