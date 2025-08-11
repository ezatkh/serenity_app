// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PdfService {
//   static Future<void> openPdfFromBytes(Uint8List pdfBytes, String fileName) async {
//     try {
//       final dir = await getTemporaryDirectory();
//       final file = File('${dir.path}/$fileName');
//
//       await file.writeAsBytes(pdfBytes, flush: true);
//
//       final result = await OpenFile.open(file.path);
//
//       if (result.type != ResultType.done) {
//         print('Failed to open file: ${result.message}');
//       }
//     } catch (e) {
//       print('Error opening PDF: $e');
//     }
//   }
// }
