import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../../../data/Models/account_profile.dart';
import '../../../core/services/api/base/api_service.dart';
import '../profile_viewmodel/profile_viewmodel.dart';
import './widgets/body_content.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _pendingFetchAfterReconnect = false;

  final List<String> genderOptions = ['Male', 'Female','Custom','Not Specified'];
  String? selectedGender;
  int _currentFetchId = 0;

  final TextEditingController nifController = TextEditingController(text: "");
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController dobController = TextEditingController(text: "");
  final TextEditingController addressStreetController = TextEditingController(text: "");
  final TextEditingController addressCityController = TextEditingController(text: "");
  final TextEditingController addressPostalCodeController = TextEditingController(text: "");
  final TextEditingController doorNumberController = TextEditingController(text: "");
  final TextEditingController apartmentNumberController = TextEditingController(text: "");
  final TextEditingController countryController = TextEditingController(text: "");
  final TextEditingController statusController = TextEditingController(text: "");
  final TextEditingController joinDateController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController emergencyConstantNameController = TextEditingController(text: "");
  final TextEditingController emergencyConstantPhoneController = TextEditingController(text: "");
  final TextEditingController clientManagerController = TextEditingController(text: "");
  final TextEditingController caseManagerController = TextEditingController(text: "");


  @override
  void initState() {
    super.initState();
    selectedGender = "Not Specified";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      viewModel.setEditing(false);
      _fetchAndFillProfile(viewModel);
    });

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .map((results) =>
    results.isNotEmpty ? results.first : ConnectivityResult.none)
        .listen((result) {
      if (result == ConnectivityResult.none) {
        _pendingFetchAfterReconnect = true;
        final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
        viewModel.setEditing(false);
        ToastService.show(type: ToastType.error, message: 'Internet lost');
      }
      else if (_pendingFetchAfterReconnect) {
        ToastService.show(type: ToastType.success, message: 'Internet reconnected, fetching...');
        _pendingFetchAfterReconnect = false;
        final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
        _fetchAndFillProfile(viewModel);
      }
    });

  }

  Future<void> _fetchAndFillProfile(ProfileViewModel viewModel) async {
    final fetchId = ++_currentFetchId;
    try {
      await viewModel.fetchProfile(context,forceRefresh: true);
      if (!mounted) return;
      if (fetchId != _currentFetchId) return;
      _fillControllersFromProfile(viewModel.profile);
    } catch (e) {
      ToastService.show(type: ToastType.error, message: 'unexpected error :$e');
    }
  }

  void _fillControllersFromProfile(AccountProfile? profile) {
    if (profile == null) return;

    setState(() {
      nifController.text = profile.nif ?? '';
      nameController.text = profile.name ?? '';
      emailController.text = profile.email ?? '';
      phoneController.text = profile.phoneNumber ?? '';
      emergencyConstantNameController.text = profile.emergencyContactName ?? '';
      emergencyConstantPhoneController.text = profile.emergencyContactPhone ?? '';
      dobController.text = profile.dateOfBirth ?? '';
      joinDateController.text = profile.joinDate ?? '';
      addressStreetController.text = profile.billingAddressStreet ?? '';
      addressCityController.text = profile.billingAddressCity ?? '';
      addressPostalCodeController.text = profile.billingAddressPostalCode ?? '';
      doorNumberController.text = profile.doorNumber ?? '';
      apartmentNumberController.text = profile.apartmentNumber ?? '';
      countryController.text = profile.countryOfOrigin ?? '';
      caseManagerController.text = profile.caseManager ?? '';
      clientManagerController.text = profile.clientManager ?? '';
      statusController.text=profile.status ?? '';
      if (profile.gender != null && profile.gender!.trim().isNotEmpty) {
        final matchedOption = genderOptions.firstWhere(
              (option) => option.toLowerCase() == profile.gender!.toLowerCase(),
          orElse: () => 'Not Specified',
        );
        selectedGender = matchedOption;
      } else {
        selectedGender = 'Not Specified';
      }
    });
  }

  Future<void> _handleProfileEditOrUpdate(ProfileViewModel viewModel) async {
    bool hasInternet = await ApiRequest().checkConnectivity();
    if (!hasInternet) {
      ToastService.show(type: ToastType.error, message: 'No internet connection');
      return;
    }
    if (viewModel.isEditing) {
      final profile = AccountProfile(
        email: emailController.text.trim(),
        countryOfOrigin: countryController.text.trim(),
        gender: selectedGender,
        doorNumber: doorNumberController.text.trim(),
        billingAddressStreet: addressStreetController.text.trim(),
        billingAddressCity: addressCityController.text.trim(),
        billingAddressPostalCode: addressPostalCodeController.text.trim(),
        apartmentNumber: apartmentNumberController.text.trim(),
        dateOfBirth: dobController.text.trim(),
        name: nameController.text.trim(),
        emergencyContactName: emergencyConstantNameController.text.trim(),
        emergencyContactPhone: emergencyConstantPhoneController.text.trim(),
      );

      await viewModel.updateProfile(
        context,
        profile: profile,
      );
      await _fetchAndFillProfile(viewModel);
    }
    viewModel.toggleEditMode();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    nifController.dispose();
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    addressStreetController.dispose();
    addressCityController.dispose();
    addressPostalCodeController.dispose();
    doorNumberController.dispose();
    apartmentNumberController.dispose();
    countryController.dispose();
    statusController.dispose();
    joinDateController.dispose();
    emergencyConstantNameController.dispose();
    emergencyConstantPhoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    final appLocalization = Provider.of<LocalizationService>(context, listen: false);

    return Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          final isEditing = profileViewModel.isEditing;
          final isLoading = profileViewModel.isLoading;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.white,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light, // For iOS
                ),
                title: Text(
                  appLocalization.getLocalizedString("profile"),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.w500
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              bottomNavigationBar:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    ),
                    onPressed:() => _handleProfileEditOrUpdate(profileViewModel),
                    child: Text(
                      isEditing
                          ? appLocalization.getLocalizedString("save")
                          : appLocalization.getLocalizedString("editProfile"),
                      style: TextStyle(color: AppColors.white, fontSize: 15 * scale),
                    ),
                  ),
                ),
              ),

              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                const CircleAvatar(
                                  radius: 60,
                                  backgroundColor: AppColors.primaryLighterColor,
                                  backgroundImage: AssetImage(
                                      'assets/images/person.png'),
                                ),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.secondaryColor,
                                  child: Image.asset(
                                    'assets/icons/edit.png',
                                    width: 14,
                                    height: 14,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            BodyFields(
                              isEditing: isEditing,
                              scale: scale,
                              appLocalization: appLocalization,
                              nifController: nifController,
                              nameController: nameController,
                              emailController: emailController,
                              phoneController: phoneController,
                              emergencyConstantNameController: emergencyConstantNameController,
                              emergencyConstantPhoneController: emergencyConstantPhoneController,
                              dobController: dobController,
                              joinDateController: joinDateController,
                              addressStreetController: addressStreetController,
                              addressCityController: addressCityController,
                              addressPostalCodeController: addressPostalCodeController,
                              doorNumberController: doorNumberController,
                              apartmentNumberController: apartmentNumberController,
                              countryController: countryController,
                              selectedGender: selectedGender,
                              genderOptions: genderOptions,
                              onGenderChanged: (val) {
                                setState(() {
                                  selectedGender = val;
                                });
                              },
                              caseManagerController: caseManagerController,
                              clientManagerController: clientManagerController,
                              statusController: statusController,
                              // onSaveOrUpdate: () => _handleProfileEditOrUpdate(profileViewModel),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isLoading) ...[
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
          );
        }
    );
  }

}
