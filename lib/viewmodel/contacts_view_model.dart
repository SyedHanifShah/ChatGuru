import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsViewModel with ChangeNotifier {
  void getContacts(String uid) async {
    List<Contact> contacts = await ContactsService.getContacts();

    var userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    var userData = await userDocRef.get();
    if (userData.exists) {
      List<Map<String, dynamic>> contactsData = contacts.map((contact) {
        return {
          'name': contact.displayName ?? '',
          'phone': contact.phones?.isNotEmpty == true
              ? contact.phones?.first.value
              : '',
          // Add more fields as needed
        };
      }).toList();
      List<Map<String, dynamic>> existingContacts = [];

      // Get existing contacts or initialize an empty list
      if (userData.data() != null && userData.data()!['contacts'] != null) {
        existingContacts = (userData.data()!['contacts'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
      }
      // Combine existing contacts with new contacts
      List<Map<String, dynamic>> updatedContacts = [
        ...existingContacts,
        ...contactsData
      ];

      // Update only the 'contacts' field
      await userDocRef.update({'contacts': updatedContacts});
    }
  }

  Future<void> askPermissions(BuildContext context) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleInvalidPermissions(context, permissionStatus);
      });
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(
      BuildContext context, PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> isContactInUsersCollection(String contactNumber) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('number', isEqualTo: contactNumber)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> filterContacts(
    List<Map<String, dynamic>> contactsData,
  ) async {
    List<Map<String, dynamic>> filteredContacts = [];
    List<Future<void>> tasks = [];

    for (var contact in contactsData) {
      tasks.add(isContactInUsersCollection(contact['phone'])
          .then((isInUsersCollection) {
        if (isInUsersCollection) {
          filteredContacts.add(contact);
        }
      }));
    }

    await Future.wait(tasks);
    return filteredContacts;
  }
}
