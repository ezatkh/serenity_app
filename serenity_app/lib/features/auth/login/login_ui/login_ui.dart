import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/auth/login/login_ui/widgets/login_form.dart';
import '../../../../core/services/local/LocalizationService.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.4);

    final horizontalPadding = 60.0 * scale;
    final verticalPadding = 30.0 * scale;
    final titleFontSize = (16.0 * scale).clamp(14.0, 24.0);
    final logoWidth = size.width * 0.6;
    final gap = 15.0 * scale;

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

        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
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
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: verticalPadding,
                      vertical: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${appLocalization.getLocalizedString("welcomeTo")}",
                          style: TextStyle(
                            color: AppColors.primaryBoldColor,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: gap),
                        Image.asset(
                          'assets/icons/loginLogo.png',
                          width: logoWidth,
                        ),
                        SizedBox(height: gap),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${appLocalization.getLocalizedString("login")}',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: gap),
                        LoginForm(
                          onLoadingChanged: setLoading,
                        ),
                        SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) ...[
                const ModalBarrier(
                  dismissible: false,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                ),
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.primaryLighterColor,
                    size: 60,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }
}
