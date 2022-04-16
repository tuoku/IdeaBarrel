import 'package:image_picker/image_picker.dart';

import '../models/storage.dart';

class StorageRepo {
  // --- singleton boilerplate
  static final StorageRepo _storageRepo = StorageRepo._internal();
  factory StorageRepo() {
    return _storageRepo;
  }
  StorageRepo._internal();
  // ---

  final storage = Storage();

  Future<String?> uploadImage(XFile image) async {
    final res = await storage.uploadImage(image);
    return res;
  }
}
