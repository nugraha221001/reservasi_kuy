import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoreData {
  final FirebaseStorage _storageFirebase = FirebaseStorage.instance;

  /// upload image ke storage firebase
  uploadImageToStorage(
      String folderName, String childName, Uint8List file) async {
    Reference ref = _storageFirebase.ref(folderName).child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadedUrl = await snapshot.ref.getDownloadURL();
    return downloadedUrl;
  }

  /// fungsi upload foto
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  }
}
