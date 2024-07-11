enum NotificationType { rejected, activated }

class NotificationModel {
  final String docId;
  final String subtitle;
  final String title;
  final NotificationType type;
  final bool isRead;
  final String userToDoc;
  final int dateTime;

  NotificationModel({
    required this.subtitle,
    required this.title,
    required this.type,
    required this.docId,
    required this.isRead,
    required this.userToDoc,
    required this.dateTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      subtitle: json['subtitle'] as String? ?? "",
      title: json['title'] as String? ?? "",
      type: (json['notif_type'] as String? ?? "") == "rejected"
          ? NotificationType.rejected
          : NotificationType.activated,
      docId: json['id'] as String? ?? "",
      isRead: json['is_read'] as bool? ?? false,
      userToDoc: json['user_id'] as String? ?? "",
      dateTime: json['created_at'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtitle': subtitle,
      'title': title,
      'notif_type':
          type == NotificationType.rejected ? "rejected" : "activated",
      'user_id': userToDoc,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      "id": docId,
      "is_read": isRead,
      'notif_type':
          type == NotificationType.rejected ? "rejected" : "activated",
      'subtitle': subtitle,
      'title': title,
      'user_id': userToDoc,
    };
  }

  //{
  //   "id": "3e9d00bb-a8a5-4ba1-83ff-a11223c95d56",
  //   "is_read": true,
  //   "notif_type": "rejected",
  //   "subtitle": "string",
  //   "title": "string",
  //   "user_id": "string"
  // }

  NotificationModel copyWith({
    String? subtitle,
    String? title,
    NotificationType? type,
    String? docId,
    bool? isRead,
    String? userToDoc,
    int? dateTime,
  }) {
    return NotificationModel(
      subtitle: subtitle ?? this.subtitle,
      title: title ?? this.title,
      type: type ?? this.type,
      docId: docId ?? this.docId,
      isRead: isRead ?? this.isRead,
      userToDoc: userToDoc ?? this.userToDoc,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
