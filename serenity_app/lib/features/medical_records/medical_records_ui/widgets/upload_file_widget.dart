import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/local/LocalizationService.dart';

class UploadFileWidget extends StatefulWidget {
  final double scale;
  final String label;
  final Function(File?) onFileSelected;
  final File? fileToShow;

  const UploadFileWidget({
    Key? key,
    required this.scale,
    required this.label,
    required this.onFileSelected,
    this.fileToShow,
  }) : super(key: key);

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  File? selectedFile;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
        widget.onFileSelected(selectedFile);
      }
    } catch (e) {
      print("File pick error: $e");
    }
  }

  void clearFile() {
    setState(() {
      selectedFile = null;
    });
  }

  @override
  void didUpdateWidget(covariant UploadFileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileToShow != selectedFile) {
      setState(() {
        selectedFile = widget.fileToShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final labelFontSize = (12.0 * widget.scale).clamp(12.0, 14.0);


    return Padding(
      padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: AppColors.greyLabelText,
              fontSize: labelFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload,
                    color: AppColors.secondaryColor,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedFile != null
                        ? selectedFile!.path.split('/').last
                        : appLocalization.getLocalizedString("supportedTypes"),
                    style: TextStyle(
                      fontSize: 13 * widget.scale,
                      color: AppColors.greyLabelText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
