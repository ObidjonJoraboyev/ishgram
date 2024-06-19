import 'package:equatable/equatable.dart';
import 'package:ish_top/data/models/notification_model.dart';

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;
  final StatusOfNotif status;

  const NotificationState({required this.notifications, required this.status});

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    StatusOfNotif? status,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        status,
      ];
}

enum StatusOfNotif {
  loading,
  success,
  error,
  pure,
}
