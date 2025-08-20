import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/core/constants/app_colors.dart';
import 'package:serenity_app/features/home/home_ui/widgets/home_body.dart';
import 'package:serenity_app/features/home/home_ui/widgets/home_header.dart';
import '../../../core/services/local/LocalizationService.dart';
import '../home_viewmodel/home_viewmodel.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..fetchHomeData(),
      child: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryBoldColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: _HomeContent(),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.primaryBoldColor,
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(username: viewModel.profile?.name ?? ''),
            Expanded(
              child: HomeBody(
                programType: viewModel.profile?.programType != null && viewModel.profile!.programType!.isNotEmpty
                    ? viewModel.profile!.programType![0]
                    :  appLocalization.getLocalizedString('noProgramAssigned'),
                isLoading: viewModel.profileLoading || viewModel.appointmentLoading,
                nextAppointment: viewModel.nextAppointment,
                errorMessage: viewModel.errorMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
