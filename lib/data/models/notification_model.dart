class NotificationModel {
  final String docId;
  final String subtitle;
  final String title;
  final NotificationType type;
  final bool isRead;
  final String userToDoc;
  final String dateTime;

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
      type: (json['type'] as String? ?? "") == "rejected"
          ? NotificationType.rejected
          : NotificationType.actived,
      docId: json['docId'] as String? ?? "",
      isRead: json['isRead'] as bool? ?? false,
      userToDoc: json['userToDoc'] as String? ?? "",
      dateTime: json['dateTime'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'subtitle': subtitle,
      'title': title,
      'type': type == NotificationType.rejected ? "rejected" : "actived",
      'isRead': isRead,
      'userToDoc': userToDoc,
      'dateTime': dateTime,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'subtitle': subtitle,
      'title': title,
      'type': type == NotificationType.rejected ? "rejected" : "actived",
      'isRead': isRead,
      'userToDoc': userToDoc,
      'dateTime': dateTime,
    };
  }

  NotificationModel copyWith({
    String? subtitle,
    String? title,
    NotificationType? type,
    String? docId,
    bool? isRead,
    String? userToDoc,
    String? dateTime,
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

enum NotificationType { rejected, actived }
