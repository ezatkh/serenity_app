import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import '../../../../core/services/local/LocalizationService.dart';
import '../../../../data/Models/medical_report_model.dart';
import '../../../../widgets/expandable_text.dart';
import '../../../../widgets/label_value_column.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../../medical_records_viewmodel/medical_records_viewmodel.dart';
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
          '${widget.medicalRecordItem.name}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20 * widget.scale,
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
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                      Text(
                        widget.medicalRecordItem.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * widget.scale,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('medicalFolder'),
                            value: widget.medicalRecordItem.pMRName ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelValueColumn(
                            label: appLocalization.getLocalizedString('uploadDateTime'),
                            value: widget.medicalRecordItem.createdByName ?? '',
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ],
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
                      const SizedBox(height: 32),
                    ],
                ),
                  ),
              );
            }
          },
        ),
      ),
    );
  }
}

