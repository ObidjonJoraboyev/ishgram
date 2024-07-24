import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String messageId;
  final String messageText;
  final int createdTime;
  final String idFrom;
  final String idTo;
  final bool isEdited;

  const MessageModel({
    required this.idFrom,
    required this.idTo,
    required this.messageText,
    required this.messageId,
    required this.createdTime,
    required this.isEdited,
  });

  Map<String, dynamic> toJson() => {
        "id_from": idFrom,
        "id_to": idTo,
        "doc_id": messageId,
        "message_text": messageText,
        "created_time": createdTime,
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "id_from": idFrom,
        "id_to": idTo,
        "message_text": messageText,
        "created_time": createdTime,
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idFrom: json["id_from"] as String? ?? "",
      idTo: json["ann_id"] as String? ?? "",
      messageText: json["text"] as String? ?? "",
      messageId: json["id"] as String? ?? "",
      createdTime: json["created_at"] as int? ?? 0,
      isEdited: json["is_edited"] as bool? ?? false,
    );
  }

  //   "id": "c256cf35-872b-4a18-b618-e37cde5b8f79",
  //       "ann_id": "31e76a1b-35c6-4217-8004-c3c09c91136e",
  //       "id_from": "dfd7f911-f5e3-4d52-a730-04c9fe367980",
  //       "text": "sdasdfasdf",
  //       "created_at": 1721762165466,
  //       "is_edited": false

  static MessageModel initialValue = const MessageModel(
    idFrom: "",
    idTo: "",
    messageText: "",
    messageId: "",
    createdTime: 0,
    isEdited: false,
  );

  MessageModel copyWith({
    String? messageId,
    String? messageText,
    int? createdTime,
    String? idFrom,
    String? idTo,
    bool? isEdited,
  }) {
    return MessageModel(
      idFrom: idFrom ?? this.idFrom,
      idTo: idTo ?? this.idTo,
      messageText: messageText ?? this.messageText,
      messageId: messageId ?? this.messageId,
      createdTime: createdTime ?? this.createdTime,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  @override
  List<Object?> get props => [
        messageId,
        messageText,
        idTo,
        idFrom,
        createdTime,
        isEdited,
      ];
}
