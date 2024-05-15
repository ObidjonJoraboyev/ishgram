import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ish_top/data/models/announcement.dart';

abstract class ImageEvent extends Equatable {}

class ImageSetEvent extends ImageEvent {
  ImageSetEvent({
    required this.pickedFile,
    required this.images,
  });

  final List<XFile> pickedFile;
  final List<ImageModel> images;

  @override
  List<Object?> get props => [pickedFile];
}

class ImageRemoveEvent extends ImageEvent {
  ImageRemoveEvent({required this.docId});

  final String docId;

  @override
  List<Object?> get props => [docId];
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
