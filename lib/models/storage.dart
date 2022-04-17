import 'dart:typed_data';

import 'package:azblob/azblob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  final storage = AzureStorage.parse(dotenv.env['STORAGE_CONSTR']!);

  // uploads image and returns the resulting URL of the image or null if unsuccesful
  Future<String?> uploadImage(XFile image) async {
    try {
      String fileName = image.name;
      // read file as Uint8List
      Uint8List content = await image.readAsBytes();
      String container = "img";
      // get the mine type of the file
      String contentType = image.mimeType ?? "";
      await storage.putBlob('/$container/$fileName',
          bodyBytes: content,
          contentType: contentType,
          type: BlobType.BlockBlob);

      return ("https://innobarrel.blob.core.windows.net/img/$fileName");
    } on AzureStorageException catch (ex) {
      if (kDebugMode) print(ex.message);
    } catch (err) {
      if (kDebugMode) print(err);
    }
    return null;
  }
}
