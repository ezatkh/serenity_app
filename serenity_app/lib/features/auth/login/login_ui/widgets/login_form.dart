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
import 'international_phone_number_input.dart';

class LoginForm extends StatefulWidget {

  final void Function(bool isLoading)? onLoadingChanged;

  const LoginForm({super.key, this.onLoadingChanged});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String fullPhoneNumber = '';
  final TextEditingController nifController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  bool _submitted = false;
  bool isChecked = false;
  String? nifError;
  String? phoneError;
  bool showTermsError = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);

    final gap15 = 15.0 * scale;
    final gap20 = 20.0 * scale;
    final checkboxScale = scale * 1.2;
    final fontSize12 = (12.0 * scale).clamp(12.0, 14.0);
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: appLocalization.getLocalizedString("nif"),
            controller: nifController,
            keyboardType: TextInputType.number,
            scale:scale,
            maxLength: 9,
            onChanged: (value) {
              if (nifError != null) {
                setState(() {
                  nifError = null;
                });
              }
            },
          ),
          if (_submitted && nifError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                nifError!,
                style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
              ),
            ),
          SizedBox(height: gap15),
          CustomPhoneNumberField(
            label: "Mobile",
            controller: mobileController,
            scale: scale,
            hint: '123456789',
            onChanged: (phoneNumber) {
              fullPhoneNumber = phoneNumber.completeNumber;
              print("on changed full number :${fullPhoneNumber}");
              if (phoneError != null) {
                setState(() {
                  phoneError = null;
                });
              }
            },
          ),
          if (_submitted && phoneError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                phoneError!,
                style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
              ),
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
                        width: 1,
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
                    checkColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: gap15),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text:  appLocalization.getLocalizedString("conditionsPart1"),
                    style:  TextStyle(
                      fontSize: fontSize12,
                      letterSpacing: 0.12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: appLocalization.getLocalizedString("conditionsPart2"),
                        style: TextStyle(
                          color: AppColors.primaryBoldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize12,
                          letterSpacing: 0.12,
                        ),
                      ),
                      TextSpan(
                        text: appLocalization.getLocalizedString("conditionsPart3"),
                      ),
                      TextSpan(
                        text: appLocalization.getLocalizedString("conditionsPart4"),
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
          if (_submitted && showTermsError)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                appLocalization.getLocalizedString("pleaseAcceptTerms"),
                style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
              ),
            ),
          SizedBox(height: gap20),
          CustomButton(
            text: appLocalization.getLocalizedString("continue"),
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
    setState(() {
      _submitted = true;
    });

    final loginHelper = LoginViewModel();
    final newNifError = loginHelper.validateNIF(nifController.text);
    final newPhoneError = loginHelper.validatePhone(mobileController.text);
    final termsAccepted = loginHelper.validateTerms(isChecked);

    setState(() {
      nifError = newNifError;
      phoneError = newPhoneError;
      showTermsError = !termsAccepted;
    });

    if (!isChecked) {
      setState(() {
        showTermsError = true;
      });
    } else {
      setState(() {
        showTermsError = false;
      });
    }

    if (newNifError != null || newPhoneError != null || !termsAccepted) {
      return;
    }

    widget.onLoadingChanged?.call(true);

    try {
      final response = await loginHelper.handleNifCheck(
        nif: nifController.text.trim(),
        mobile: mobileController.text.trim(),
        context: context,
      );

      final status = response['status'];
      final data = response['data'];
      final success = response['success'];

      if (status == 200 && success && data["total"] > 0) {
        final List<dynamic> accountInfo = data['list'];
        final String userId = accountInfo[0]['id'];
        await SharedPrefsUtil.saveString(USER_ID, userId);

        final normalizedPhone = LoginViewModel.normalizeContact(fullPhoneNumber);
        print("the normalized phone number is :${normalizedPhone}");
        await SharedPrefsUtil.saveString('isLoggedIn', 'true');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpUI(
              controller: OtpController(
                emailOrPhone: normalizedPhone,
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
      // else {
      //   await SharedPrefsUtil.saveString(USER_ID, '66269e8ccb598e60d');
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (_) => const DashboardUI()),
      //         (route) => false,
      //   );
      // }
    } catch (e) {
      // You can handle error here if needed
    } finally {
      widget.onLoadingChanged?.call(false);
    }
  }
}