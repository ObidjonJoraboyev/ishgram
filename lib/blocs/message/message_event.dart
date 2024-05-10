
 import 'package:equatable/equatable.dart';

import '../../data/models/message_model.dart';
class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}
class MessageGetEvent extends MessageEvent {
  const MessageGetEvent();

  @override
  List<Object?> get props => [];
}
class MessageDeleteEvent extends MessageEvent {

  const MessageDeleteEvent({required this.docId});
  final String docId;
  @override
  List<Object?> get props => [];
}
class MessageAddEvent extends MessageEvent {
  final MessageModel messages;
  const MessageAddEvent({required this.messages});

  @override
  List<Object?> get props => [];
}
