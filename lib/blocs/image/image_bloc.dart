import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_event.dart';

class ImageBloc extends Bloc<ImageEvent, String> {
  ImageBloc() : super('') {
    on<ImageEvent>(
      (event, emit) async {
        try {
          var ref = FirebaseStorage.instance.ref().child(event.storagePath);
          File file = File(event.pickedFile.path);

          var uploadTask = await ref.putFile(file);

          String downloadUrl = await uploadTask.ref.getDownloadURL();
          emit(downloadUrl);
        } on FirebaseException catch (error) {
          debugPrint(error.message);
          throw Exception();
        }
      },
    );
  }
}
