import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String messageId;

  final String messageText;

  final String updatedTime;
  final String createdTime;
  final bool isSupport;
  final List<String> images;
  final String idFrom;

  final String idTo;

  const MessageModel({
    required this.idFrom,
    required this.idTo,
    required this.updatedTime,
    required this.messageText,
    required this.messageId,
    required this.isSupport,
    required this.createdTime,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
        "id_from": idFrom,
        "id_to": idTo,
        "doc_id": messageId,
        "message_text": messageText,
        "created_time": createdTime,
        "updated_time": updatedTime,
        "status": isSupport,
      };

  Map<String, dynamic> toJsonForUpdate() => {
        "id_from": idFrom,
        "id_to": idTo,
        "message_text": messageText,
        "created_time": createdTime,
        "updated_time": updatedTime,
        "status": isSupport,
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idFrom: json["id_from"] as String? ?? "",
      idTo: json["id_to"] as String? ?? "",
      updatedTime: json["created_time"] as String? ?? "",
      messageText: json["message_text"] as String? ?? "",
      messageId: json["doc_id"] as String? ?? "",
      isSupport: json["status"] as bool? ?? false,
      createdTime: json["updated_time"] as String? ?? "",
      images: json["images"] as List<String>? ?? [],
    );
  }

  static MessageModel initialValue = const MessageModel(
    idFrom: "",
    idTo: "",
    updatedTime: "",
    messageText: "",
    messageId: "",
    isSupport: false,
    createdTime: "",
    images: [],
  );

  MessageModel copyWith({
    String? messageId,
    String? messageText,
    String? createdTime,
    String? updatedTime,
    String? idFrom,
    String? idTo,
    bool? isSupport,
    List<String>? images,
  }) {
    return MessageModel(
        idFrom: idFrom ?? this.idFrom,
        idTo: idTo ?? this.idTo,
        updatedTime: updatedTime ?? this.updatedTime,
        messageText: messageText ?? this.messageText,
        messageId: messageId ?? this.messageId,
        isSupport: isSupport ?? this.isSupport,
        createdTime: createdTime ?? this.createdTime,
        images: images ?? this.images);
  }

  @override
  List<Object?> get props => [
        messageId,
        messageText,
        idTo,
        idFrom,
        isSupport,
        updatedTime,
        createdTime,
        images
      ];
}
