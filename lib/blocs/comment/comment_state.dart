import 'package:equatable/equatable.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/message_model.dart';

class MessageState extends Equatable {
  const MessageState({required this.messages, required this.formStatus});

  final List<MessageModel> messages;
  final FormStatus formStatus;

  MessageState copyWith(
      {List<MessageModel>? messages, FormStatus? formStatus}) {
    return MessageState(
      messages: messages ?? this.messages,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object> get props => [];
}
