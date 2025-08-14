import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/medical_records/medical_records_ui/widgets/medical_record_item_skeleton.dart';
import 'package:serenity_app/features/medical_records/medical_records_ui/widgets/medical_record_item_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../core/services/local/LocalizationService.dart';
import '../../../data/Models/medical_report_model.dart';
import '../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../medical_records_viewmodel/medical_records_viewmodel.dart';

class MedicalRecordsUI extends StatefulWidget {
  final Function(MedicalRecordModel)? onMedicalRecordSelected;

  const MedicalRecordsUI({Key? key, this.onMedicalRecordSelected}) : super(key: key);
  @override
  State<MedicalRecordsUI> createState() => _MedicalRecordsUIState();
}

class _MedicalRecordsUIState extends State<MedicalRecordsUI> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);
      if (!medicalRecordsVM.isLoading && medicalRecordsVM.medicalRecords.isEmpty) {
        medicalRecordsVM.fetchMedicalRecords(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);

    return  WillPopScope(
      onWillPop: () async {
        dashboardVM.setCurrentIndex(0);
        return false;
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
            onPressed: () {
              dashboardVM.setCurrentIndex(0);
            },
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.black),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {
                  final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
                  dashboardVM.setCurrentIndex(8);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor, // Purple color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  elevation: 0, // Remove shadow if you want flat look
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 14 * scale),
                    SizedBox(width: 4),
                    Text(
                      Provider.of<LocalizationService>(context, listen: false).getLocalizedString('new'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11 * scale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                    style: TextStyle(fontSize: 16 * scale),
                  ),
                );
              }else {
                return RefreshIndicator(
                  onRefresh: () async {
                    final vm = Provider.of<MedicalRecordsViewModel>(context, listen: false);
                    vm.resetFetched();
                    await vm.fetchMedicalRecords(context);
                  },
                  child: ListView.builder(
                    itemCount: medicalRecordsVM.medicalRecords.length,
                    itemBuilder: (context, index) {
                      final medicalRecordItem = medicalRecordsVM.medicalRecords[index];
                      return MedicalRecordItemWidget(
                        medicalRecordItem: medicalRecordItem,
                        scale: scale,
                        onTap: () {
                          if (widget.onMedicalRecordSelected != null) {
                            widget.onMedicalRecordSelected!(medicalRecordItem);
                          }
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}