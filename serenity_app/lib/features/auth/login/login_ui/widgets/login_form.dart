import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

import '../../../../../core/services/LocalizationService.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../otp/otp_ui/otp_ui.dart';
import '../../../otp/otp_viewmodel/otp_viewmodel.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController nifController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);

    final gap15 = 15.0 * scale;
    final gap20 = 20.0 * scale;
    final checkboxScale = scale * 1.2;
    final fontSize12 = (12.0 * scale).clamp(12.0, 14.0);

    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "${appLocalization.getLocalizedString("nif")}",
      //    label: "nif",
          controller: nifController,
          keyboardType: TextInputType.number,
          scale:scale
        ),
        SizedBox(height: gap15),
        CustomTextField(
          label: "${appLocalization.getLocalizedString("emailAndMobile")}",
         // label: "emailAndMobile",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hint: 'example@email.com',
          scale:scale
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
              //    text:  "conditionsPart1",
                  text:  "${appLocalization.getLocalizedString("conditionsPart1")}",
                  style:  TextStyle(
                    fontSize: fontSize12,
                    letterSpacing: 0.12,
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                //      text: "conditionsPart2",
                      text: "${appLocalization.getLocalizedString("conditionsPart2")}",
                      style: TextStyle(
                        color: AppColors.primaryBoldColor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize12,
                        letterSpacing: 0.12,
                      ),
                    ),
                    TextSpan(
                    //  text: "conditionsPart3",
                      text: "${appLocalization.getLocalizedString("conditionsPart3")}",
                    ),
                    TextSpan(
                    //  text: "conditionsPart4",
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
        SizedBox(height: gap20),
        CustomButton(
          text: '${appLocalization.getLocalizedString("continue")}',
       //   text: 'continue',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpUI(
                  controller: OtpController(
                    userId: "user@example.com",
                    deliveryMethod: "email",
                    onVerified: () {
                      // Navigate to the next screen
                    },
                  ),
                ),
              ),
            );
          },
          isEnabled: true,
          fontSize: 15,
          textColor: AppColors.white,
          borderRadius: 12,
          backgroundColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
