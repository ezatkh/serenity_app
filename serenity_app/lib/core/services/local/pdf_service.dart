import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileService {
  /// Saves a file to temporary directory.
  /// [bytes] - file content
  /// [filename] - name without extension
  /// [fileExtension] - e.g., 'pdf', 'jpg', 'png'
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
      final extension = mimeTypeToExtension(mimeType); // default to pdf if null
      print("Saving file with extension: $extension");

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

  static String mimeTypeToExtension(String? mimeType) {
    if (mimeType == null) return 'pdf'; // default fallback
    final parts = mimeType.split('/');
    return (parts.length == 2 && parts[1].isNotEmpty) ? parts[1] : 'pdf';
  }
}
