import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CommonFirebaseStorageRepositoryprovider =
    Provider((ref) => CommonFirebaseStorageRepository(
          firebaseStorage: FirebaseStorage.instance,
        ));

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({required this.firebaseStorage});

  Future<String> storefiletofirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    var downloadurl = taskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }
}
