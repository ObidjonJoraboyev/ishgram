import 'package:equatable/equatable.dart';

import '../../data/models/message_model.dart';

class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageGetState extends MessageState {
  const MessageGetState({required this.messages});

  final List<MessageModel> messages;

  @override
  List<Object> get props => [];
}

class MessageAddState extends MessageState {
  @override
  List<Object> get props => [];
}
