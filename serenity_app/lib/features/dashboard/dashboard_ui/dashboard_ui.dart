import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/appointments/appointment_viewmodel/appointments_viewmodel.dart';
import 'package:serenity_app/features/dashboard/dashboard_ui/widgets/bottom_navigation_bar_item.dart';
import 'package:serenity_app/features/medical_records/medical_records_viewmodel/medical_records_viewmodel.dart';
import '../../../core/services/local/LocalizationService.dart';
import '../../appointments/appointment_ui/appointment_ui.dart';
import '../../appointments/appointment_ui/widgets/appoitment_item_detail_widget.dart';
import '../../cases/cases_ui/cases_ui.dart';
import '../../cases/cases_ui/widgets/case_item_detail_widget.dart';
import '../../cases/cases_viewmodel/cases_viewmodel.dart';
import '../../chat/chat_ui/chat_ui.dart';
import '../../home/home_ui/home_ui.dart';
import '../../medical_records/medical_records_ui/medical_records_ui.dart';
import '../../medical_records/medical_records_ui/widgets/medical_record_item_detail_widget.dart';
import '../../medical_records/medical_records_ui/widgets/new_medical_record.dart';
import '../../profile/profile_ui/profile_ui.dart';
import '../../settings/settings_ui/settings_ui.dart';
import '../dashboard_viewmodel/dashboard_viewmodel.dart';

class DashboardUI extends StatefulWidget {

  const DashboardUI({super.key});


  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {

  late List<Widget> _tabs;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final casesVM = Provider.of<CasesViewModel>(context, listen: false);
    final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);
    final appointmentsVM = Provider.of<AppointmentsViewModel>(context, listen: false);

    _tabs = [
      const HomeUI(),//index 0
      const ChatUI(),//index 1
      const ProfileUI(),//index 2
      const SettingsUI(),//index 3
      CasesUI(
        onCaseSelected: (caseItem) {
          casesVM.selectCase(caseItem);
          Provider.of<DashboardViewModel>(context, listen: false).setCurrentIndex(5);
        },
      ),//index 4
      Consumer<CasesViewModel>(
        builder: (context, casesVM, child) {
          final selectedCase = casesVM.selectedCase;
          if (selectedCase == null) {
            return const Center(child: Text('No case selected'));
          }
          final size = MediaQuery.of(context).size;
          final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
          return CaseItemDetailWidget(caseItem: selectedCase, scale: scale);
        },
      ),//index 5
      MedicalRecordsUI(
        onMedicalRecordSelected: (medicalRecordItem) {
          medicalRecordsVM.selectMedicalRecord(medicalRecordItem);
          Provider.of<DashboardViewModel>(context, listen: false).setCurrentIndex(7);
        },
      ),//index 6
      Consumer<MedicalRecordsViewModel>(
        builder: (context, medicalRecordVM, child) {
          final selectedMedicalRecord = medicalRecordVM.selectedMedicalRecord;
          if (selectedMedicalRecord == null) {
            return const Center(child: Text('No medical record selected'));
          }
          final size = MediaQuery.of(context).size;
          final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
          return MedicalRecordItemDetailWidget(medicalRecordItem: selectedMedicalRecord, scale: scale);
        },
      ),//index 7
      MedicalRecordNewItem(),//index 8
      AppointmentsUI(
        onAppointmentSelected: (appointmentItem) {
          appointmentsVM.selectAppointment(appointmentItem);
          Provider.of<DashboardViewModel>(context, listen: false).setCurrentIndex(10);
        },
      ),//index 9
      Consumer<AppointmentsViewModel>(
        builder: (context, appointmentVM, child) {
          final selectedAppointment = appointmentVM.selectedAppointment;
          if (selectedAppointment == null) {
            return const Center(child: Text('No medical record selected'));
          }
          final size = MediaQuery.of(context).size;
          final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
          return AppointmentItemDetailWidget(appointmentItem: selectedAppointment, scale: scale);
        },
      ),//index 10
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    final iconSize = 24.0 * scale;

    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _tabs[dashboardVM.currentIndex],
      ),
      bottomNavigationBar:
      Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: dashboardVM.currentIndex >= 4 ? 0 : dashboardVM.currentIndex,
          onTap: (index) => dashboardVM.setCurrentIndex(index),
          selectedItemColor: AppColors.secondaryColor,
          unselectedItemColor: AppColors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            buildNavItem(icon: Icons.home, label: appLocalization.getLocalizedString("home"), index: 0, currentIndex: dashboardVM.currentIndex >= 4 ? 0 : dashboardVM.currentIndex, iconSize: iconSize),
            buildNavItem(icon: Icons.chat_bubble_outline, label: appLocalization.getLocalizedString("chat"), index: 1, currentIndex: dashboardVM.currentIndex >= 4 ? 0 : dashboardVM.currentIndex, iconSize: iconSize),
            buildNavItem(icon: Icons.person_outline, label: appLocalization.getLocalizedString("profile"), index: 2, currentIndex: dashboardVM.currentIndex >= 4 ? 0 : dashboardVM.currentIndex, iconSize: iconSize),
            buildNavItem(icon: Icons.settings, label: appLocalization.getLocalizedString("settings"), index: 3, currentIndex: dashboardVM.currentIndex >= 4 ? 0 : dashboardVM.currentIndex, iconSize: iconSize),
          ],
        ),
      ),
    );
  }

}
