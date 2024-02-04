import 'package:chat_app/viewmodel/contacts_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final contactsViewModel = Provider.of<ContactsViewModel>(context);

    contactsViewModel.askPermissions(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (ctx, snp) {
                if (snp.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator if data is still loading
                  return const Center(child: CircularProgressIndicator());
                } else if (snp.hasError) {
                  // Handle any errors
                  return Text('Error: ${snp.error}');
                } else {
                  // Process the data and build your UI

                  List<Map<String, dynamic>> contactsData = [];

                  if (snp.data != null && snp.data!.exists) {
                    Map<String, dynamic> data =
                        snp.data!.data() as Map<String, dynamic>;
                    contactsData = (data['contacts'] as List<dynamic>).cast<
                        Map<String,
                            dynamic>>(); // Cast the List<dynamic> to List<Map<String, dynamic>>
                  }

                  return FutureBuilder(
                      future: contactsViewModel.filterContacts(contactsData),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!snp.hasData) {
                          return const Text('No Contact available');
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Map<String, dynamic>> filteredContacts =
                              snapshot.data!;

                          return ListView.builder(
                              itemCount: filteredContacts.length,
                              itemBuilder: (BuildContext context, int index) {
                                // Your UI code here for each contact in filteredContacts
                                return ListTile(
                                  title: Text(filteredContacts[index]['name']),
                                );
                              });
                        }
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
