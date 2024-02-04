import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatViewModel with ChangeNotifier {
  final _currentUser = FirebaseAuth.instance.currentUser!;

  DocumentSnapshot<Map<String, dynamic>>? _currentOppositeUser;
  DocumentSnapshot<Map<String, dynamic>>? get currentOppositeUser =>
      _currentOppositeUser;

  void setCurrentOppositeUser(
      DocumentSnapshot<Map<String, dynamic>> oppositeUser) {
    _currentOppositeUser = oppositeUser;
  }

  Future<String> getCurrentUserData() async {
    String imageUri = '';

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // Adjust collection name if needed
        .doc(_currentUser.uid)
        .get();
    imageUri = userDoc.get('image_url');

    return imageUri;
  }

  Future<Map<String, List<dynamic>>> getUserInfo(
    String currentUserId,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> messages,
  ) async {
    Map<String, List<dynamic>> loadedMessages = {};
    Set<String> processedUserIds = <String>{};

    for (final message in messages) {
      final otherUserId = message['senderId'] == currentUserId
          ? message['receiverId']
          : message['senderId'];
      if (!processedUserIds.contains(otherUserId)) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Adjust collection name if needed
            .doc(otherUserId)
            .get();

        final userData = {
          'username': userDoc.get('username'),
          'image_url': userDoc.get('image_url'), // Add image_url retrieval
        };

        loadedMessages
            .putIfAbsent(otherUserId, () => [])
            .add({...message.data(), ...userData});
        processedUserIds.add(otherUserId);
      }
    }
    return loadedMessages;
  }
}
