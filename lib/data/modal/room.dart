import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String username;
  final String userImage;
  final String lastMessage;

  Room({
    required this.userImage,
    required this.username,
    required this.lastMessage,
  });

  factory Room.fromDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Room(
      userImage: data['image_url'] ?? '',
      username: data['username'] ?? '',
      lastMessage: data['last_message'] ?? '',
    );
  }
}
