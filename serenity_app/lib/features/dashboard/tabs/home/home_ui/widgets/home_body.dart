import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/dashboard/tabs/home/home_ui/widgets/program_card.dart';

import '../../../../../../core/services/LocalizationService.dart';
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
                DashboardTile(title: appLocalization.getLocalizedString("subscriptions"), icon: Icons.star_border),
                DashboardTile(title: appLocalization.getLocalizedString("cases"), icon: Icons.folder_open),
                DashboardTile(title: appLocalization.getLocalizedString("medicalRecords"), icon: Icons.medical_services),
                DashboardTile(title: appLocalization.getLocalizedString("documents"), icon: Icons.description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


//
// // Example: Program Card (Gold Care)
// Container(
// width: double.infinity,
// padding: const EdgeInsets.all(16),
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// AppColors.primaryColor.withOpacity(0.9),
// AppColors.primaryColor.withOpacity(0.6),
// ],
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// ),
// borderRadius: BorderRadius.circular(20),
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// const Text(
// "Program Name",
// style: TextStyle(color: Colors.white, fontSize: 14),
// ),
// const SizedBox(height: 4),
// const Text(
// "Gold Care",
// style: TextStyle(
// color: Colors.white,
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// const SizedBox(height: 12),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// const Text(
// "Subscription status",
// style: TextStyle(color: Colors.white70, fontSize: 13),
// ),
// Container(
// padding:
// const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// decoration: BoxDecoration(
// color: AppColors.errorColor,
// borderRadius: BorderRadius.circular(12),
// ),
// child: const Text(
// "Active",
// style: TextStyle(
// color: Colors.white,
// fontSize: 12,
// fontWeight: FontWeight.w600,
// ),
// ),
// )
// ],
// )
// ],
// ),
// ),
//
// const SizedBox(height: 20),