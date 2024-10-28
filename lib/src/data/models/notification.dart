import 'package:intl/intl.dart';

class Notification {
  String? id;
  String notificationType, message, userId;
  bool isRead;
  DateTime sentAt;
  DateTime? readAt;
  Map<String, dynamic>? metadata;

  Notification({
    this.id,
    required this.notificationType,
    required this.message,
    required this.userId,
    required this.isRead,
    required this.sentAt,
    this.readAt,
    this.metadata,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      notificationType: json['notification_type'],
      message: json['message'],
      userId: json['user_id'],
      isRead: json['is_read'],
      sentAt: DateTime.parse(json['sent_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'notification_type': notificationType,
      'message': message,
      'user_id': userId,
      'is_read': isRead,
      'sent_at': formatter.format(sentAt),
      'read_at': readAt != null ? formatter.format(readAt!) : null,
      'metadata': metadata,
    };
  }
}
