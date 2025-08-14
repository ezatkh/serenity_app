import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';

import '../../../../core/services/local/LocalizationService.dart';
import '../../../../widgets/custom_button.dart';
import '../otp_viewmodel/otp_viewmodel.dart';

class OtpUI extends StatefulWidget {
  final OtpController controller;

  const OtpUI({Key? key, required this.controller}) : super(key: key);

  @override
  State<OtpUI> createState() => _OtpUIState();
}

class _OtpUIState extends State<OtpUI> {
  final TextEditingController _pinController = TextEditingController();
  String _enteredPin = "";
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.sendOtp();
    widget.controller.timer.addListener(() => setState(() {}));
    widget.controller.error.addListener(() {
      final errorValue = widget.controller.error.value;
      print("widget.controller.error : $errorValue");

      setState(() {
        _isLoading = false; // stop loading on error

        if (errorValue != null) {
          if (errorValue.contains("blocked all requests from this device")) {
            // Custom message for blocked device
            _errorMessage =
            "Your device has been temporarily blocked due to unusual activity. Please try again later or use another device.";
          } else if (errorValue.contains("invalid verification code")) {
            // Custom message for invalid OTP
            _errorMessage =
            "The activation code you entered is invalid. Please check the code and try again.";
          } else {
            // Fallback message for other errors
            _errorMessage = errorValue;
          }
        } else {
          _errorMessage = null;
        }
      });
    });

  }

  @override
  void dispose() {
    _pinController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  void _resendCode() {
    if (widget.controller.timer.value == 0) {
      widget.controller.resendOtp();
      setState(() {
        _errorMessage = null;
      });
    }
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await widget.controller.verifyOtp(_enteredPin);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);
    final fontSize = (16 * scale).clamp(14.0, 20.0);
    final pinBoxSize = 56.0 * scale;

    final defaultPinTheme = PinTheme(
      width: pinBoxSize,
      height: pinBoxSize,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey,width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
    );


    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.backgroundColor,
      ),
    );

    var appLocalization = Provider.of<LocalizationService>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/bottomShape.png',
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      appLocalization.getLocalizedString("enterOtpCode"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 10 * scale),
                    Text(
                      appLocalization.getLocalizedString("a6digitCodeWasSentTo"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize ,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(height: 20 * scale),
                    Pinput(
                      length: 6,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      onChanged: (pin) {
                        setState(() {
                          _enteredPin = pin;
                        });
                      },
                      onCompleted: (_) => _verifyOtp(),
                      autofocus: true,
                      showCursor: true,
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: fontSize * 0.85),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 100 * scale),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                    CustomButton(
                      text: appLocalization.getLocalizedString("continue"),
                      onPressed: (_enteredPin.length == 6 && !_isLoading)
                          ? _verifyOtp
                          : () {},
                      isEnabled: _enteredPin.length == 6 && !_isLoading,
                      fontSize: fontSize * 0.95,
                      textColor: AppColors.white,
                      borderRadius: 12,
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    SizedBox(height: 10 * scale),
                    ValueListenableBuilder<int>(
                      valueListenable: widget.controller.timer,
                      builder: (context, value, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(appLocalization.getLocalizedString("didntRecieveAnyCode")),
                            TextButton(
                              onPressed: value == 0 ? _resendCode : null,
                              child: Text(
                                value == 0
                                    ? "Resend"
                                    : "Resend in $value s",
                                style: TextStyle(
                                  color: value == 0 ? AppColors.primaryColor : AppColors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

