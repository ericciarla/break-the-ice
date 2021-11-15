import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path_provider/path_provider.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> UploadImage(String filePath, String fileName) async {
    fileName = fileName;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(filePath);
    Image? image = decodeImage(file.readAsBytesSync());
    Image resize = copyResize(image!, width: 400);
    File('$tempPath/$fileName.jpg').writeAsBytes(encodeJpg(resize));
    //File newFile = File('$tempPath/$fileName.jpg');
    var compressedImage = File('$tempPath/$fileName.jpg')
      ..writeAsBytesSync(encodeJpg(resize, quality: 85));
    print(compressedImage.path);
    try {
      try {
        await storage.ref("user_images/$fileName").delete();
      } on firebase_core.FirebaseException catch (e) {}

      await storage.ref("user_images/$fileName").putFile(compressedImage);
      compressedImage.delete();
      file.delete();

      print("deleted");
      return storage.ref("user_images/$fileName").getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      print(e.plugin);
      print(e);
    }
    return null;
  }
}
