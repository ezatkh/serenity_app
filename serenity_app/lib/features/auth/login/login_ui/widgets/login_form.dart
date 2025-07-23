import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../dashboard/dashboard_ui/dashboard_ui.dart';
import '../../../otp/otp_ui/otp_ui.dart';
import '../../../otp/otp_viewmodel/otp_viewmodel.dart';
import '../../login_viewmodel/login_viewmodel.dart';
import '../../../../../widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {

  final void Function(bool isLoading)? onLoadingChanged;

  const LoginForm({super.key, this.onLoadingChanged});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isChecked = false;
  bool showTermsError = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);

    final gap15 = 15.0 * scale;
    final gap20 = 20.0 * scale;
    final checkboxScale = scale * 1.2;
    final fontSize12 = (12.0 * scale).clamp(12.0, 14.0);
    final loginHelper = LoginViewModel();
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: "${appLocalization.getLocalizedString("nif")}",
            controller: nifController,
            keyboardType: TextInputType.number,
            scale:scale,
            validator: loginHelper.validateNIF,
          ),
          SizedBox(height: gap15),
          CustomTextField(
            label: "${appLocalization.getLocalizedString("emailAndMobile")}",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            hint: 'example@email.com',
            scale:scale,
            validator: loginHelper.validateContact,
          ),
          SizedBox(height: gap15),
          Row(
            children: [
              Transform.scale(
                scale: checkboxScale,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: AppColors.grey,
                    checkboxTheme: CheckboxThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: const BorderSide(
                        color: AppColors.grey,
                        width: 1.5,
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                        if (isChecked) showTermsError = false;
                      });
                    },
                    activeColor: AppColors.secondaryColor,
                  ),
                ),
              ),
              SizedBox(height: gap15),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text:  "${appLocalization.getLocalizedString("conditionsPart1")}",
                    style:  TextStyle(
                      fontSize: fontSize12,
                      letterSpacing: 0.12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "${appLocalization.getLocalizedString("conditionsPart2")}",
                        style: TextStyle(
                          color: AppColors.primaryBoldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize12,
                          letterSpacing: 0.12,
                        ),
                      ),
                      TextSpan(
                        text: "${appLocalization.getLocalizedString("conditionsPart3")}",
                      ),
                      TextSpan(
                        text: "${appLocalization.getLocalizedString("conditionsPart4")}",
                        style: TextStyle(
                          color: AppColors.primaryBoldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize12,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showTermsError)
            Padding(
              padding: EdgeInsets.only(left: 48, top: 4), // align with checkbox start
              child: Text(
                appLocalization.getLocalizedString("pleaseAcceptTerms"),
                style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
              ),
            ),
          SizedBox(height: gap20),
          CustomButton(
            text: '${appLocalization.getLocalizedString("continue")}',
            onPressed: _handleSubmit,
            isEnabled: true,
            fontSize: 15,
            textColor: AppColors.white,
            borderRadius: 12,
            backgroundColor: AppColors.secondaryColor,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final isFormValid = _formKey.currentState!.validate();

    if (!isChecked) {
      setState(() {
        showTermsError = true;
      });
    } else {
      setState(() {
        showTermsError = false;
      });
    }

    if (!isFormValid || !isChecked) return;

    widget.onLoadingChanged?.call(true);

    try {
      final loginHelper = LoginViewModel();

      final response = await loginHelper.handleNifCheck(
        nif: nifController.text.trim(),
        context: context,
      );

      final status = response['status'];
      final data = response['data'];
      final success = response['success'];

      if (status == 200 && success && data["total"] > 0) {
        final List<dynamic> accountInfo = data['list'];
        final String userId = accountInfo[0]['id'];
        await SharedPrefsUtil.saveString(USER_ID, userId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpUI(
              controller: OtpController(
                emailOrPhone: emailController.text,
                onVerified: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardUI()),
                        (route) => false,
                  );
                },
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // You can handle error here if needed
    } finally {
      // 🔘 Stop loading
      widget.onLoadingChanged?.call(false);
    }
  }
}