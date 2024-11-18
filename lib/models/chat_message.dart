import 'package:eventure/services/db/models/entity.dart';

class ChatMessage implements Entity {
  ChatMessage({
    this.id,
    required this.name,
    required this.text,
    required this.timestamp,
    required this.userId,
  });

  final String? id;
  final String name;
  final String text;
  final int timestamp;
  final String userId;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': text,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      name: map['name'],
      text: map['message'],
      timestamp: map['timestamp'],
      userId: map['userId'],
    );
  }
}
