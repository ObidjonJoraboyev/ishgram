import 'package:image_picker/image_picker.dart';
import 'package:ish_top/data/models/user_model.dart';

abstract class UserEvent {}

class GetCurrentUser extends UserEvent {}

class GetAllUsers extends UserEvent {}

class UpdateUser extends UserEvent {
  final UserModel userModel;

  UpdateUser({required this.userModel});
}

class AuthUpdateProfileUser extends UserEvent {
  AuthUpdateProfileUser({
    required this.pickedFile,
  });

  final XFile pickedFile;
}

class AuthDeleteImage extends UserEvent {}
