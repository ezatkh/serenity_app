import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/home/home_ui/widgets/program_card.dart';
import '../../../../../../core/services/local/LocalizationService.dart';
import '../../../../core/constants/constants.dart';
import '../../../../data/Models/appointments_model.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import 'coming_appointment_card.dart';
import 'dashboard_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBody extends StatelessWidget {
  final String? programType;
  final String? status;
  final bool isLoading;
  final AppointmentModel? nextAppointment;
  final String? errorMessage;

  const HomeBody({
    super.key,
    this.programType,
    this.status,
    required this.isLoading,
    this.nextAppointment,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProgramCard(
                programName: appLocalization.getLocalizedString("programName") ,
                programType:  programType ?? '',
                statusText: status ?? '' ,
              ),
            ),
            SizedBox(height: 20),
            // Add main content widgets here
            ComingAppointmentCard(
              title: appLocalization.getLocalizedString("comingAppointment"),
              date: nextAppointment?.dateStart
                  ?? appLocalization.getLocalizedString("notAvailable"),
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              crossAxisSpacing: 20,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3, // Adjust to control item height
              children: [
                DashboardTile(title: appLocalization.getLocalizedString("medicalRecords"), icon: Icons.medical_services,
                  onTap: () {
                    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
                    dashboardVM.setCurrentIndex(6);
                  },
                ),
                DashboardTile(title: appLocalization.getLocalizedString("cases"), icon: Icons.folder_open,
                  onTap: () {
                    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
                    dashboardVM.setCurrentIndex(4);
                  },
                ),
                DashboardTile(title: appLocalization.getLocalizedString("appointments"), icon: Icons.description,
                  onTap: () {
                  final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
                  dashboardVM.setCurrentIndex(9);
                },
                ),
                DashboardTile(title: appLocalization.getLocalizedString("emergencyCall"), icon: Icons.add_ic_call,
                  onTap: () async {
                    callEmergencyNumber();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callEmergencyNumber() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: EMERGENCY_NUMBER,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Calling not supported on this device');
    }
  }
}