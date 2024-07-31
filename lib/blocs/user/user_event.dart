import 'package:image_picker/image_picker.dart';
import 'package:ish_top/data/models/user_model.dart';

abstract class UserEvent {}

class GetCurrentUser extends UserEvent {}

class GetAllUsers extends UserEvent {}

class UpdateUser extends UserEvent {
  final UserModel userModel;

  UpdateUser({required this.userModel});
}

class UserUpdateProfileUser extends UserEvent {
  UserUpdateProfileUser({
    required this.pickedFile,
  });

  final XFile pickedFile;
}

class UserDeleteImage extends UserEvent {}

class UserGetWithQr extends UserEvent {
  final String phoneNumber;
  final String string;
  UserGetWithQr({required this.phoneNumber, required this.string});
}

class UserRemoveUsername extends UserEvent {}

class UserUpdateUsername extends UserEvent {
  final String username;
  UserUpdateUsername({required this.username});
}
