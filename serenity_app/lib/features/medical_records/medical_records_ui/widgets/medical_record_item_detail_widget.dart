import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/core/utils/extensions.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/services/local/LocalizationService.dart';
import '../../../../core/services/local/pdf_service.dart';
import '../../../../core/services/local/toast_service.dart';
import '../../../../data/Models/medical_report_model.dart';
import '../../../../widgets/expandable_text.dart';
import '../../../../widgets/label_value_column.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../../medical_records_viewmodel/medical_records_viewmodel.dart';
import 'clickable_label_value.dart';
import 'file_popup_menu.dart';
import 'medical_record_item_skeleton.dart';
import 'package:open_file/open_file.dart';

class MedicalRecordItemDetailWidget extends StatefulWidget {
  final MedicalRecordModel medicalRecordItem;
  final double scale;
  final VoidCallback? onTap;

  const MedicalRecordItemDetailWidget({
    Key? key,
    required this.medicalRecordItem,
    required this.scale,
    this.onTap,
  }) : super(key: key);

  @override
  State<MedicalRecordItemDetailWidget> createState() => _MedicalRecordItemDetailWidgetState();
}

class _MedicalRecordItemDetailWidgetState extends State<MedicalRecordItemDetailWidget> {
  bool _descExpanded = false;

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);


    final labelStyle = TextStyle(
      color: AppColors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 11 * widget.scale,
    );

    final valueStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14 * widget.scale,
      color: Colors.black87,
    );

    final seeMoreStyle = TextStyle(
      color: AppColors.secondaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 13 * widget.scale,
    );

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          widget.medicalRecordItem.name.toString().withoutExtension(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18 * widget.scale,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            dashboardVM.setCurrentIndex(6);
          },
        ),
        iconTheme: const IconThemeData(
          color: AppColors.black,
        ),
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Consumer<MedicalRecordsViewModel>(
          builder: (context, medicalRecordsVM, child) {
            if (medicalRecordsVM.isLoading) {
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => const MedicalRecordItemSkeleton(),
              );
            } else if (medicalRecordsVM.medicalRecords.isEmpty) {
              return Center(
                child: Text(
                  appLocalization.getLocalizedString("no_medicalRecords_found"),
                  style: TextStyle(fontSize: 16 * widget.scale),
                ),
              );
            }else {
              return
                Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      child: Column(
                        children: [
                          // First Card - Details
                          Container(
                            padding: const EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.medicalRecordItem.name.toString().withoutExtension(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16 * widget.scale,
                                          color: AppColors.black,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                LabelValueColumn(
                                  label: appLocalization.getLocalizedString('medicalFolder'),
                                  value: widget.medicalRecordItem.pMRName ?? '',
                                  labelStyle: labelStyle,
                                  valueStyle: valueStyle,
                                ),
                                const SizedBox(height: 18),
                                LabelValueColumn(
                                  label: appLocalization.getLocalizedString('uploadDateTime'),
                                  value: widget.medicalRecordItem.createdByName ?? '',
                                  labelStyle: labelStyle,
                                  valueStyle: valueStyle,
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  appLocalization.getLocalizedString('description'),
                                  style: labelStyle,
                                ),
                                const SizedBox(height: 6),
                                ExpandableText(
                                  text: widget.medicalRecordItem.description ?? '',
                                  expanded: _descExpanded,
                                  onToggle: () => setState(() => _descExpanded = !_descExpanded),
                                  textStyle: valueStyle,
                                  seeMoreStyle: seeMoreStyle,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40), // space between the two cards

                          Container(
                            padding: const EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appLocalization.getLocalizedString('file'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18 * widget.scale,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    CustomPopupMenu(
                                      onSelected: (option) {
                                        switch (option) {
                                          case FileMenuOption.download:
                                            _handleDownload();
                                            break;
                                          case FileMenuOption.view:
                                            _handleView();
                                            break;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClickableLabelValue(
                                  value: widget.medicalRecordItem.fileName ?? '',
                                  onValueTap: () {
                                    print('File id ${widget.medicalRecordItem.fileId}');
                                    // final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);
                                    // medicalRecordsVM.fetchMedicalRecordFile(widget.medicalRecordItem.fileId ?? '');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (medicalRecordsVM.isLoadingFile) ...[
                      const ModalBarrier(
                        dismissible: false,
                        color: Color.fromRGBO(255, 255, 255, 0.7), // white with 70% opacity
                      ),
                      Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.primaryLighterColor,
                          size: 60,
                        ),
                      ),
                    ],
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      }

      if (await Permission.storage.isDenied) {
        var status = await Permission.storage.request();
        if (status.isGranted) return true;
      }

      // For Android 11 and above
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      if (await Permission.manageExternalStorage.isDenied) {
        var status = await Permission.manageExternalStorage.request();
        if (status.isGranted) return true;
      }

      if (await Permission.manageExternalStorage.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied) {
        return await _showPermissionDialog();
      }

      return false;
    }

    return true; // iOS doesn't need storage permission
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission is required to download files. Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop(true);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    ) ?? false;
  }


  Future<void> _handleDownload() async {
    final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);

    try {
      // Step 1: Ask for storage permission
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        ToastService.show(
          message: 'Storage permission is required to download the file',
          type: ToastType.info,
        );
        return;
      }

      // Step 2: Fetch file data from API
      final response = await medicalRecordsVM.fetchMedicalRecordFile(
        widget.medicalRecordItem.fileId ?? '',
      );

      if (response != null && response is Uint8List) {
        final fileName = widget.medicalRecordItem.fileName ?? 'medical_report.pdf';

        // Step 3: Ask user where to save
        final selectedDirectory = await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory == null) {
          print("❌ User canceled folder selection");
          return;
        }

        // Step 4: Build file path and save
        final filePath = path.join(selectedDirectory, fileName);
        final file = File(filePath);
        await file.writeAsBytes(response);

        ToastService.show(
          message: 'Report downloaded successfully',
          type: ToastType.success,
        );
      } else {
        ToastService.show(
          message: 'Failed to get PDF data.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastService.show(
        message: "Error downloading file: $e",
        type: ToastType.error,
      );
    }
  }

  Future<void> _handleView() async {
    final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);

    try {
      final response = await medicalRecordsVM.fetchMedicalRecordFile(widget.medicalRecordItem.fileId ?? '');

      if (response != null && response is Uint8List) {

        final file = await PdfService.savePdf(response, 'medical_report_123');
        if (file != null) {

          final result = await OpenFile.open(file.path);

          print('Open file result: ${result.type}');

          // await file.delete();
        } else {
          print('Failed to save the PDF file');
        }      } else {
        print('Failed to get PDF data or wrong format');
      }
    } catch (e) {
      print('Error opening PDF: $e');
    }
  }
}

