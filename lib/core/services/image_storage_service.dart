import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageStorageService {
  static final ImageStorageService _instance = ImageStorageService._internal();
  factory ImageStorageService() => _instance;
  ImageStorageService._internal();

  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  /// Get the app's data directory (AppData on Windows)
  Future<Directory> _getAppDataDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    // Create app-specific folder structure: AppData/Roaming/quanly/
    final appDataDir = Directory(path.join(appDocDir.path, 'quanly'));
    if (!await appDataDir.exists()) {
      await appDataDir.create(recursive: true);
    }
    return appDataDir;
  }

  /// Get the images cache directory
  Future<Directory> _getImagesDirectory() async {
    final appDataDir = await _getAppDataDirectory();
    final imagesDir = Directory(path.join(appDataDir.path, 'cache', 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  /// Pick an image from gallery or camera
  /// Returns the file path if successful, null otherwise
  Future<String?> pickAndSaveImage({ImageSource source = ImageSource.gallery}) async {
    try {
      // Pick image
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, // Compress to 85% quality
        maxWidth: 1920, // Max width
        maxHeight: 1920, // Max height
      );

      if (pickedFile == null) {
        return null;
      }

      // Get images directory
      final imagesDir = await _getImagesDirectory();
      
      // Generate unique filename
      final extension = path.extension(pickedFile.path);
      final filename = '${_uuid.v4()}$extension';
      final targetPath = path.join(imagesDir.path, filename);

      // Copy file to app's cache directory
      final sourceFile = File(pickedFile.path);
      final targetFile = await sourceFile.copy(targetPath);

      // Return relative path from app data directory for storage in DB
      // This makes it easier to migrate or backup
      final appDataDir = await _getAppDataDirectory();
      final relativePath = path.relative(targetFile.path, from: appDataDir.path);
      
      return relativePath;
    } catch (e) {
      print('Error picking/saving image: $e');
      return null;
    }
  }

  /// Get full file path from relative path stored in database
  Future<String?> getFullImagePath(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      return null;
    }

    try {
      final appDataDir = await _getAppDataDirectory();
      final fullPath = path.join(appDataDir.path, relativePath);
      final file = File(fullPath);
      
      if (await file.exists()) {
        return fullPath;
      }
      return null;
    } catch (e) {
      print('Error getting full image path: $e');
      return null;
    }
  }

  /// Delete an image file
  Future<bool> deleteImage(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      return false;
    }

    try {
      final fullPath = await getFullImagePath(relativePath);
      if (fullPath != null) {
        final file = File(fullPath);
        if (await file.exists()) {
          await file.delete();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Show image picker source selection dialog
  Future<String?> pickImageWithSource() async {
    // For now, just use gallery. Can be extended to show dialog
    return await pickAndSaveImage(source: ImageSource.gallery);
  }
}

