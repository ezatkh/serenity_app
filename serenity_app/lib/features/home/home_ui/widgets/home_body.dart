import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/home/home_ui/widgets/program_card.dart';
import '../../../../../../core/services/local/LocalizationService.dart';
import '../../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import 'coming_appointment_card.dart';
import 'dashboard_tile.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

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
                programType: appLocalization.getLocalizedString("goldCare") ,
                statusText: appLocalization.getLocalizedString("active") ,
              ),
            ),
            SizedBox(height: 20),
            // Add main content widgets here
            ComingAppointmentCard(
              title: appLocalization.getLocalizedString("comingAppointment"),
              date: "Aug 30, 2025 at 10:00 AM",
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
                DashboardTile(title: appLocalization.getLocalizedString("subscriptions"), icon: Icons.star_border,
                  onTap: () {
                    // TODO: Navigate to Documents screen
                  },),
                DashboardTile(title: appLocalization.getLocalizedString("cases"), icon: Icons.folder_open,
                  onTap: () {
                    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
                    dashboardVM.setCurrentIndex(4);
                  },
                ),
                DashboardTile(title: appLocalization.getLocalizedString("medicalRecords"), icon: Icons.medical_services,
                  onTap: () {
                    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
                    dashboardVM.setCurrentIndex(6);
                  },),
                DashboardTile(title: appLocalization.getLocalizedString("appointments"), icon: Icons.description,    onTap: () {
                    // TODO: Navigate to Documents screen
                },),
              ],
            ),
          ],
        ),
      ),
    );
  }
}