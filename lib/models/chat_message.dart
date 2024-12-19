import 'package:eventure/services/db/models/entity.dart';

class ChatMessage implements Entity {
  ChatMessage({
    this.id,
    required this.text,
    required this.timestamp,
    required this.userId,
    required this.eventId,
  });

  final String? id;
  final String text;
  final int timestamp;
  final String userId;
  final String eventId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'message': text,
      'timestamp': timestamp,
      'userId': userId,
      'eventId': eventId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
        text: map['message'],
        timestamp: map['timestamp'],
        userId: map['userId'],
        eventId: map['eventId']);
  }
}
