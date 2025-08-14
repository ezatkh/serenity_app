import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  /// Convert any file to Base64 with proper MIME type
  static Future<String> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes(); // Read binary safely
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final base64Str = base64Encode(bytes);
      return 'data:$mimeType;base64,$base64Str';
    } catch (e) {
      throw Exception('Error encoding file to Base64: $e');
    }
  }

  /// Get MIME type of a file
  static String getMimeType(File file) {
    return lookupMimeType(file.path) ?? 'application/octet-stream';
  }

  /// Get file name from path
  static String getFileName(File file) {
    return file.path.split('/').last;
  }

  /// Check if file type is supported (optional helper)
  static bool isSupportedFile(File file, List<String> allowedMimeTypes) {
    final mimeType = lookupMimeType(file.path);
    return mimeType != null && allowedMimeTypes.contains(mimeType);
  }

  static Future<File?> saveFile(
      Uint8List bytes,
      String filename,
      String? mimeType,
      ) async {
    if (bytes.isEmpty) {
      print('File is empty.');
      return null;
    }

    try {
      // Use MIME library to get extension dynamically
      final extension = mimeType != null
          ? extensionFromMime(mimeType)
          : 'application/octet-stream'; // fallback

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename.$extension');

      await file.writeAsBytes(bytes);
      print('File saved at: ${file.path}');
      return file;
    } catch (e) {
      print('Error saving file: $e');
      return null;
    }
  }

  /// Converts MIME type to file extension using `mime` package
  static String extensionFromMime(String mimeType) {
    final ext = extensionFromMime(mimeType); // <-- this comes from 'package:mime/mime.dart'
    return ext ?? 'bin'; // fallback for unknown MIME
  }
}
