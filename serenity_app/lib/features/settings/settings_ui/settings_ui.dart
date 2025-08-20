import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/appointments/appointment_viewmodel/appointments_viewmodel.dart';
import 'package:serenity_app/features/settings/settings_ui/widgets/confirmation_dialog.dart';
import 'package:serenity_app/features/settings/settings_ui/widgets/settings_tile.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../core/constants/constants.dart';
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
    await SharedPrefsUtil.remove(IS_LOGGIN);
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          appLocalization.getLocalizedString("settings"),
          style: TextStyle(
            color: Colors.black,
            fontSize: 22 * scale,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Settings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                children: [
                  const SizedBox(height: 50),

                  SettingsTile(
                    icon: Icons.notifications,
                    title: appLocalization.getLocalizedString("notification"),
                    onTap: () {
                      // logic
                    },
                  ),
                  const SizedBox(height: 8),

                  SettingsTile(
                    icon: Icons.info_outline,
                    title: appLocalization.getLocalizedString("aboutUs"),
                    onTap: () {
                      // logic
                    },
                  ),
                  const SizedBox(height: 8),

                  SettingsTile(
                    icon: Icons.logout,
                    title: appLocalization.getLocalizedString("logout"),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (_) => ConfirmationDialog(
                          title: appLocalization.getLocalizedString("logout"),
                          content: appLocalization.getLocalizedString("logoutBody"),
                          confirmText: appLocalization.getLocalizedString("logout"),
                          cancelText: appLocalization.getLocalizedString("cancel"),
                          onConfirm: () {
                            _logout(context);
                          },
                        ),
                      );
                    },
                    iconColor: AppColors.errorColor,
                    titleColor: AppColors.errorColor,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      title: appLocalization.getLocalizedString("deactivateAccount"),
                      content: appLocalization.getLocalizedString("deactivateAccountBody"),
                      confirmText: appLocalization.getLocalizedString("deactivate"),
                      cancelText: appLocalization.getLocalizedString("cancel"),
                      onConfirm: () {
                        // Your deactivate logic here
                        print("Account deactivated!");
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Text(
                  appLocalization.getLocalizedString("deactivateAccount"),
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.errorColor,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

    );
  }
}