import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/appointments/appointment_viewmodel/appointments_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../core/services/cache/sharedPreferences.dart';
import '../../auth/login/login_ui/login_ui.dart';
import '../../cases/cases_viewmodel/cases_viewmodel.dart';
import '../../dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import '../../medical_records/medical_records_viewmodel/medical_records_viewmodel.dart';
import '../../profile/profile_viewmodel/profile_viewmodel.dart';

class SettingsUI extends StatelessWidget {
  const SettingsUI({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final casesVM = Provider.of<CasesViewModel>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final medicalRecordsVM = Provider.of<MedicalRecordsViewModel>(context, listen: false);
    final appointmentsVM = Provider.of<AppointmentsViewModel>(context, listen: false);

    casesVM.clear();
    dashboardVM.clear();
    profileVM.clear();
    medicalRecordsVM.clear();
    appointmentsVM.clear();
    SharedPrefsUtil.clear();
    await SharedPrefsUtil.remove('isLoggedIn');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginUI()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    final appLocalization = Provider.of<LocalizationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // For iOS
        ),
        title: Text(
          appLocalization.getLocalizedString("settings"),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome to Settings!'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBoldColor,
                padding: EdgeInsets.symmetric(horizontal: 40 * scale, vertical: 12 * scale),
              ),
              child: Text(
                appLocalization.getLocalizedString("logout"),
                style: TextStyle(fontSize: 16 * scale),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
