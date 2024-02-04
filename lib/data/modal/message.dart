import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String username;
  final String content;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.username,
    required this.timestamp,
  });

  factory Message.fromDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      username: data['username'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}