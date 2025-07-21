import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({Key? key}) : super(key: key);

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  // @override
  // void initState() {
  //   super.initState();
  //
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  //     statusBarColor: AppColors.white,
  //     statusBarIconBrightness: Brightness.dark,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: const SafeArea(
        child: Center(
          child: Text('Welcome to Chat!'),
        ),
      ),
    );
  }
}
