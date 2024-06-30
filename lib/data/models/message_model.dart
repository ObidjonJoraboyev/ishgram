import 'package:equatable/equatable.dart';




class MessageModel extends Equatable {
  final String messageId;
  final String messageText;
  final String createdTime;
  final String image;
  final String idFrom;
  final String idTo;

  const MessageModel({
    required this.idFrom,
    required this.idTo,
    required this.messageText,
    required this.messageId,
    required this.createdTime,
    required this.image,
  });

  Map<String, dynamic> toJson() =>
      {
        "id_from": idFrom,
        "id_to": idTo,
        "doc_id": messageId,
        "message_text": messageText,
        "created_time": createdTime,
        "image": image,

      };

  Map<String, dynamic> toJsonForUpdate() =>
      {
        "id_from": idFrom,
        "id_to": idTo,
        "message_text": messageText,
        "created_time": createdTime,
        "image": image
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idFrom: json["id_from"] as String? ?? "",
      idTo: json["id_to"] as String? ?? "",
      messageText: json["message_text"] as String? ?? "",
      messageId: json["doc_id"] as String? ?? "",
      createdTime: json["updated_time"] as String? ?? "",
      image: json["image"] as String? ?? "",
    );
  }

  static MessageModel initialValue = const MessageModel(
    idFrom: "",
    idTo: "",
    messageText: "",
    messageId: "",
    createdTime: "", image: '',
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
        image: image ?? this.image
    );
  }

  @override
  List<Object?> get props =>
      [
        messageId,
        messageText,
        idTo,
        idFrom,
        createdTime,
      ];
}
