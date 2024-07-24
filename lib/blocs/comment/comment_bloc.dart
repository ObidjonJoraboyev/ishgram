import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ish_top/blocs/auth/auth_bloc.dart';
import 'package:ish_top/blocs/comment/comment_state.dart';
import 'package:ish_top/data/forms/form_status.dart';
import 'package:ish_top/data/models/message_model.dart';
import 'comment_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc()
      : super(const MessageState(messages: [], formStatus: FormStatus.pure)) {
    on<MessageGetEvent>(getAllMessages);
    on<MessageAddEvent>(addMessage);
    on<MessageDeleteEvent>(deleteMessage);
  }

  getAllMessages(MessageGetEvent event, Emitter emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio.get(
        "https://ishgram-production.up.railway.app/api/v1/comment/${event.uuId}",
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(
            formStatus: FormStatus.success,
            messages: (response.data["comments"] as List? ?? [])
                .map((toElement) => MessageModel.fromJson(toElement))
                .toList()));
      }
    } on DioException catch (error) {
      emit(state.copyWith(formStatus: FormStatus.error));
      debugPrint("ERROR CATCH ${error.response}");
    }
  }

  addMessage(MessageAddEvent event, Emitter emit) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      Response response = await dio.post(
          "https://ishgram-production.up.railway.app/api/v1/comment",
          data: {
            "ann_id": event.messages.idTo,
            "id_from": event.messages.idFrom,
            "text": event.messages.messageText
          });
      if (response.statusCode == 201) {
        emit(state.copyWith(formStatus: FormStatus.success));
      }
    } catch (error) {
      emit(state.copyWith(formStatus: FormStatus.success));
      debugPrint("ERROR CATCH $error");
    }
  }

  deleteMessage(MessageDeleteEvent event, Emitter emit) async {}
}
