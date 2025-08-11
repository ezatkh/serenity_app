import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/core/utils/extensions.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/services/local/LocalizationService.dart';
import '../../../../core/services/local/pdf_service.dart';
import '../../../../data/Models/medical_report_model.dart';
import '../../../../widgets/expandable_text.dart';
import '../../../../widgets/label_value_column.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../../medical_records_viewmodel/medical_records_viewmodel.dart';
import 'clickable_label_value.dart';
import 'file_popup_menu.dart';
import 'medical_record_item_skeleton.dart';

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
                                    Text(
                                      widget.medicalRecordItem.name.toString().withoutExtension(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16 * widget.scale,
                                        color: AppColors.black,
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

  void _handleDownload() {
    print('Download clicked');
    // TODO: implement download functionality later
  }

  Future<void> _handleView() async {
    final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);

    try {
      final response = await medicalRecordsVM.fetchMedicalRecordFile(widget.medicalRecordItem.fileId ?? '');

      if (response != null && response is Uint8List) {

        final file = await PdfService.savePdf(response, 'medical_report_123');
        if (file != null) {
          print('File saved successfully');
          // proceed to preview or share the file
          await file.delete();
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

