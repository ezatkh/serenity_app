import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/medical_records/medical_records_ui/widgets/upload_file_widget.dart';
import 'package:serenity_app/features/medical_records/medical_records_viewmodel/medical_records_viewmodel.dart';
import '../../../../core/services/local/LocalizationService.dart';
import '../../../../core/services/local/toast_service.dart';
import '../../../../data/Models/file_model.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import 'dropdown_files_widget.dart';

class MedicalRecordNewItem extends StatefulWidget {
  const MedicalRecordNewItem({Key? key}) : super(key: key);

  @override
  State<MedicalRecordNewItem> createState() => _MedicalRecordNewItemState();
}

class _MedicalRecordNewItemState extends State<MedicalRecordNewItem> {
  final TextEditingController fileNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  MedicalFolderModel? selectedMedicalFolder;
  File? selectedFile;

  List<MedicalFolderModel> medicalFoldersOptions = [];

  String uploadedFileId="";
  String? fileError;
  String? fileNameError;
  String? medicalFolderError;
  String? descriptionError;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMedicalFolders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);

    final appLocalization =
    Provider.of<LocalizationService>(context, listen: false);
    final dashboardVM =
    Provider.of<DashboardViewModel>(context, listen: false);

    return Consumer<MedicalRecordsViewModel>(
        builder: (context, medicalRecordViewModel, child) {
          final isLoading = medicalRecordViewModel.isLoading;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.white,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.black),
                  onPressed: () => dashboardVM.setCurrentIndex(6),
                ),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    appLocalization.getLocalizedString("medicalRecords"),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            UploadFileWidget(
                              fileToShow: selectedFile,
                              scale: scale,
                              label: appLocalization.getLocalizedString("file"),
                              onFileSelected: (file) async {
                                if (file == null) return;
                                final fileName = file.path.split('/').last;
                                setState(() {
                                  selectedFile = file;
                                  fileNameController.text = fileName;
                                });

                                final fileId = await medicalRecordViewModel.uploadNewFile(
                                  context,
                                  file: file,
                                  fileName: fileName,
                                );

                                if (fileId != null && fileId.isNotEmpty) {
                                  setState(() {
                                    uploadedFileId = fileId;
                                  });

                                  ToastService.show(
                                    message: 'File uploaded successfully!',
                                    type: ToastType.success,
                                  );
                                  debugPrint('✅ File uploaded with ID: $uploadedFileId');
                                }
                                else{
                                  setState(() {
                                    fileNameController.clear();
                                    uploadedFileId="";
                                    selectedFile=null;
                                  });
                                }


                              },
                            ),
                            if (_saved && fileError != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12, top: 4),
                                  child: Text(
                                    fileError!,
                                    style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                              child: CustomTextField(
                                label: appLocalization.getLocalizedString("fileName"),
                                controller: fileNameController,
                                scale: scale,
                                labelColor: AppColors.greyLabelText,
                                enabled: true,
                                hint: appLocalization.getLocalizedString("chooseFileName"),
                              ),
                            ),
                            if (_saved && fileNameError != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12, top: 4),
                                  child: Text(
                                    fileNameError!,
                                    style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                              child: CustomDropdownTextField(
                                label:
                                appLocalization.getLocalizedString("medicalFolder"),
                                scale: scale,
                                labelColor: AppColors.greyLabelText,
                                items: medicalFoldersOptions,
                                selectedItem: selectedMedicalFolder,
                                hint: appLocalization.getLocalizedString("chooseMedicalFolder"),
                                onChanged: (value) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                        selectedMedicalFolder = value;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                            if (_saved && medicalFolderError != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12, top: 4),
                                  child: Text(
                                    medicalFolderError!,
                                    style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                              child: CustomTextField(
                                label: appLocalization.getLocalizedString("description"),
                                controller: descriptionController,
                                scale: scale,
                                labelColor: AppColors.greyLabelText,
                                enabled: true,
                                hint: appLocalization.getLocalizedString("chooseDescription"),
                              ),
                            ),
                            if (_saved && descriptionError != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12, top: 4),
                                  child: Text(
                                    descriptionError!,
                                    style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    padding: EdgeInsets.symmetric(vertical: 14 * scale),
                                  ),
                                  onPressed: () => onSaveNewMedicalRecord(
                                    descriptionController.text,
                                    selectedMedicalFolder?.id ?? "",
                                    uploadedFileId,
                                    fileNameController.text,
                                  ),
                                  child: Text(
                                    appLocalization.getLocalizedString("save"),
                                    style: TextStyle(color: AppColors.white, fontSize: 15 * scale),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isLoading) ...[
                    const ModalBarrier(
                      dismissible: false,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                    ),
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.primaryLighterColor,
                        size: 60,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        });
  }

  void _loadMedicalFolders() async {
    final medicalRecordVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);

    final folders = await medicalRecordVM.fetchMedicalFolders(context);

    if (mounted) {
      setState(() {
        medicalFoldersOptions = folders;
      });
    }
  }

  Future<void> onSaveNewMedicalRecord(String description,String medicalFolderId,String uploadedFileId,String uploadedFileName) async {
    setState(() {
      _saved = true;
      // Validation
      fileError = selectedFile == null ? "File is required" : null;
      fileNameError = uploadedFileName.trim().isEmpty ? "File name is required" : null;
      medicalFolderError = (medicalFolderId == null || medicalFolderId.trim().isEmpty)
          ? "Medical folder is required"
          : null;
      descriptionError = description.trim().isEmpty ? "Description is required" : null;
    });

    if (fileError != null ||
        fileNameError != null ||
        medicalFolderError != null ||
        descriptionError != null) {
      return;
    }
    final medicalRecordVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);
    final success = await medicalRecordVM.postMedicalRecord(
      context,
      description: description,
      medicalFolderId: medicalFolderId,
      uploadedFileId: uploadedFileId,
      uploadedFileName: uploadedFileName,
    );

    if (success) {
      final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
      dashboardVM.setCurrentIndex(6);
      descriptionController.clear();
      fileNameController.clear();
      selectedFile = null;
      selectedMedicalFolder = null;
      uploadedFileId = "";
    }
    setState(() {
      _saved = false;
    });
  }
}
