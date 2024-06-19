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
}

enum NotificationType { rejected, actived }
