import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ImageEvent extends Equatable {
  const ImageEvent({required this.pickedFile, required this.storagePath});

  final XFile pickedFile;
  final String storagePath;

  @override
  List<Object?> get props => [pickedFile, storagePath];
}

// Future<String> uploadImage(
//       {required XFile pickedFile, required String storagePath}) async {
//     try {
//       var ref = FirebaseStorage.instance.ref().child(storagePath);
//       _notify(true);
//       notifyListeners();
//       File file = File(pickedFile.path);
//
//       var uploadTask = await ref.putFile(file);
//
//       String downloadUrl = await uploadTask.ref.getDownloadURL();
//
//       _notify(false);
//       notifyListeners();
//
//       return downloadUrl;
//     } on FirebaseException catch (error) {
//       debugPrint(error.message);
//
//       throw Exception();
//     }
//   }
