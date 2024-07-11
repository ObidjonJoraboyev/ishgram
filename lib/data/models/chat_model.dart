import 'package:equatable/equatable.dart';

import 'message_model.dart';

class ChatModel extends Equatable {
  final String chatId;
  final String idFrom;
  final String idTo;
  final List<MessageModel> messages;

  const ChatModel({
    required this.chatId,
    required this.idFrom,
    required this.idTo,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "id_from": idFrom,
        "id_to": idTo,
        "messages": messages.map((message) => message.toJson()).toList(),
      };

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json["chat_id"] as String? ?? "",
      idFrom: json["id_from"] as String? ?? "",
      idTo: json["id_to"] as String? ?? "",
      messages: (json["messages"] as List)
          .map((messageJson) =>
              MessageModel.fromJson(messageJson as Map<String, dynamic>))
          .toList(),
    );
  }

  ChatModel copyWith({
    String? chatId,
    String? idFrom,
    String? idTo,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      idFrom: idFrom ?? this.idFrom,
      idTo: idTo ?? this.idTo,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        chatId,
        idFrom,
        idTo,
        messages,
      ];
}
