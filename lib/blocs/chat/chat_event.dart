import 'package:equatable/equatable.dart';

class ChatEvent extends Equatable {
  const ChatEvent({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
