import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class PdfService {
  /// Saves the PDF bytes to a temporary file.
  /// Returns the saved [File] or null if saving failed or file invalid.
  static Future<File?> savePdf(Uint8List bytes, String filename) async {
    if (bytes.length < 4) {
      print('File too small to be a valid PDF.');
      return null;
    }

    final header = String.fromCharCodes(bytes.take(4));
    if (header != '%PDF') {
      print('Invalid PDF file header.');
      return null;
    }

    try {
      print("The file format is valid");
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename.pdf');
      await file.writeAsBytes(bytes);
      print('PDF saved at: ${file.path}');
      return file;
    } catch (e) {
      print('Error saving PDF file: $e');
      return null;
    }
  }
}
