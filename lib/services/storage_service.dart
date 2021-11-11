import 'dart:io';
import 'package:image/image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path_provider/path_provider.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> UploadImage(String filePath, String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(filePath);
    Image? image = decodeImage(file.readAsBytesSync());
    Image resize = copyResize(image!, width: 300);
    File('$tempPath/$fileName.jpg').writeAsBytes(encodeJpg(resize));
    File newFile = File('$tempPath/$fileName.jpg');

    try {
      await storage.ref("user_images/$fileName").putFile(file);
      return storage.ref("user_images/$fileName").getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    return null;
  }
}
