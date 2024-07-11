import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String messageId;
  final String messageText;
  final String createdTime;
  final String idFrom;
  final String idTo;

  const MessageModel({
    required this.idFrom,
    required this.idTo,
    required this.messageText,
    required this.messageId,
    required this.createdTime,
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
      idTo: json["id_to"] as String? ?? "",
      messageText: json["message_text"] as String? ?? "",
      messageId: json["doc_id"] as String? ?? "",
      createdTime: json["updated_time"] as String? ?? "",
    );
  }

  static MessageModel initialValue = const MessageModel(
    idFrom: "",
    idTo: "",
    messageText: "",
    messageId: "",
    createdTime: "",
  );

  MessageModel copyWith({
    String? messageId,
    String? messageText,
    String? createdTime,
    String? updatedTime,
    String? idFrom,
    String? idTo,
    bool? isSupport,
    String? image,
  }) {
    return MessageModel(
      idFrom: idFrom ?? this.idFrom,
      idTo: idTo ?? this.idTo,
      messageText: messageText ?? this.messageText,
      messageId: messageId ?? this.messageId,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  List<Object?> get props => [
        messageId,
        messageText,
        idTo,
        idFrom,
        createdTime,
      ];
}
