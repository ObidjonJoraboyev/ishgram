import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String messageId;
  final String messageText;
  final String createdTime;
  final bool status;
  final String idFrom;
  final String idTo;


  const MessageModel({
    required this.idFrom,
    required this.idTo,
    required this.createdTime,
    required this.messageText,
    required this.messageId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        "id_from": idFrom,
        "id_to": idTo,
        "doc_id": messageId,
        "message_text": messageText,
        "created_time": createdTime,
        "status": status,
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "id_from": idFrom,
        "id_to": idTo,
        "message_text": messageText,
        "created_time": createdTime,
        "status": status,
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idFrom: json["id_from"] as String? ?? "",
      idTo: json["id_to"] as String? ?? "",
      createdTime: json["created_time"] as String? ?? "",
      messageText: json["message_text"] as String? ?? "",
      messageId: json["doc_id"] as String? ?? "",
      status: json["status"] as bool? ?? false,
    );
  }

  static MessageModel initialValue = const MessageModel(
      idFrom: "",
      idTo: "",
      createdTime: "",
      messageText: "",
      messageId: "",
      status: true);

  MessageModel copyWith({
    String? messageId,
    String? messageText,
    String? createdTime,
    String? idFrom,
    String? idTo,
    bool? status,
  }) {
    return MessageModel(
      idFrom: idFrom ?? this.idFrom,
      idTo: idTo ?? this.idTo,
      createdTime: createdTime ?? this.createdTime,
      messageText: messageText ?? this.messageText,
      messageId: messageId ?? this.messageId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        messageId,
        messageText,
        idTo,
        idFrom,
        status,
        createdTime,
      ];
}
