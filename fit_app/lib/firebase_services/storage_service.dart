import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FireStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Upload image and return download URL
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }

  // Get image URL by userId
  Future<String?> getImageUrl(String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Failed to get image URL: $e');
      return null;
    }
  }
}
