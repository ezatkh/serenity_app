import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/dashboard/tabs/profile/profile_ui/widgets/custom_date_field.dart';
import 'package:serenity_app/features/dashboard/tabs/profile/profile_ui/widgets/custom_dropdown_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../../../data/Models/account_profile.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/loading_avatar/loading_dialog.dart';
import '../profile_viewmodel/profile_viewmodel.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> clientManagerOptions = ['Manager1', 'Manager2','Michael Averbukh'];
  final List<String> caseManagerOptions = ['caseManager1', 'caseManager2'];
  String? selectedGender;
  String? selectedClientManager;
  String? selectedCaseManager;
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
  final TextEditingController emergencyConstantNameController = TextEditingController(text: "");
  final TextEditingController emergencyConstantPhoneController = TextEditingController(text: "");


  @override
  void initState() {
    super.initState();

    selectedGender = "Male";
    selectedClientManager = "Manager1";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      _fetchAndFillProfile(viewModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    final appLocalization = Provider.of<LocalizationService>(context, listen: false);


    return Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          final isEditing = profileViewModel.isEditing;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
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
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString("nif"),
                              controller: nifController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString("name"),
                              controller: nameController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "email"),
                              controller: emailController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomDateField(
                              label: appLocalization.getLocalizedString(
                                  "dateOfBirth"),
                              controller: dobController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomDateField(
                              label: appLocalization.getLocalizedString(
                                  "joinDate"),
                              controller: joinDateController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "addressStreet"),
                              controller: addressStreetController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "addressCity"),
                              controller: addressCityController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "addressPostal"),
                              controller: addressPostalCodeController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "doorNumber"),
                              controller: doorNumberController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "apartment"),
                              controller: apartmentNumberController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "countryOfOrigin"),
                              controller: countryController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomDropdownField(
                              label: appLocalization.getLocalizedString(
                                  "gender"),
                              selectedValue: selectedGender,
                              items: genderOptions,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                              onChanged: (val) {
                                setState(() {
                                  selectedGender = val;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomDropdownField(
                              label: appLocalization.getLocalizedString(
                                  "caseManager"),
                              selectedValue: selectedCaseManager,
                              items: caseManagerOptions,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                              onChanged: (val) {
                                setState(() {
                                  selectedCaseManager = val;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomDropdownField(
                              label: appLocalization.getLocalizedString(
                                  "clientManager"),
                              selectedValue: selectedClientManager,
                              items: clientManagerOptions,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                              onChanged: (val) {
                                setState(() {
                                  selectedClientManager = val;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "status"),
                              controller: statusController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "emergencyContactName"),
                              controller: emergencyConstantNameController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: CustomTextField(
                              label: appLocalization.getLocalizedString(
                                  "emergencyContactPhone"),
                              controller: emergencyConstantPhoneController,
                              scale: scale,
                              labelColor: AppColors.greyLabelText,
                              enabled: isEditing,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14 * scale),
                                ),
                                onPressed: () =>
                                    _handleProfileEditOrUpdate(
                                        profileViewModel),
                                child: Text(
                                  isEditing
                                      ? appLocalization.getLocalizedString(
                                      "save")
                                      : appLocalization.getLocalizedString(
                                      "update"),
                                  style: TextStyle(color: AppColors.white,
                                      fontSize: 15 * scale),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Future<void> _fetchAndFillProfile(ProfileViewModel viewModel) async {
    final fetchId = ++_currentFetchId;
    LoadingDialog.show(context);
    try {
      await viewModel.fetchProfile(context);
      if (!mounted) return;
      if (fetchId != _currentFetchId) return;
      _fillControllersFromProfile(viewModel.profile);
    } finally {
      if (fetchId == _currentFetchId) {
        LoadingDialog.hide(context);
      }
    }
  }

  void _fillControllersFromProfile(AccountProfile? profile) {
    if (profile == null) return;

    setState(() {
      nifController.text = profile.nif ?? '';
      nameController.text = profile.name ?? '';
      emailController.text = profile.email ?? '';
      dobController.text = profile.dateOfBirth ?? '';
      addressStreetController.text = profile.billingAddressStreet ?? '';
      addressCityController.text = profile.billingAddressCity ?? '';
      addressPostalCodeController.text = profile.billingAddressPostalCode ?? '';
      doorNumberController.text = profile.doorNumber ?? '';
      apartmentNumberController.text = profile.apartmentNumber ?? '';
      countryController.text = profile.countryOfOrigin ?? '';
      statusController.text = profile.status ?? '';
      joinDateController.text = profile.joinDate ?? '';
      emergencyConstantNameController.text = profile.emergencyContactName ?? '';
      emergencyConstantPhoneController.text = profile.emergencyContactPhone ?? '';

      selectedGender = genderOptions.contains(profile.gender) ? profile.gender : null;
      selectedClientManager = clientManagerOptions.contains(profile.clientManager) ? profile.clientManager : null;
      selectedCaseManager = caseManagerOptions.contains(profile.caseManager) ? profile.caseManager : null;
    });
  }

  Future<void> _handleProfileEditOrUpdate(ProfileViewModel viewModel) async {
    if (viewModel.isEditing) {
      LoadingDialog.show(context);
      await viewModel.updateProfile(
        context,
        nameController: nameController,
        emailController: emailController,
        dobController: dobController,
        addressStreetController: addressStreetController,
        addressCityController: addressCityController,
        addressPostalCodeController: addressPostalCodeController,
        doorNumberController: doorNumberController,
        apartmentNumberController: apartmentNumberController,
        countryController: countryController,
        emergencyConstantNameController: emergencyConstantNameController,
        emergencyConstantPhoneController: emergencyConstantPhoneController,
        statusController: statusController,
        nifController:nifController
      );
      LoadingDialog.hide(context);
      await _fetchAndFillProfile(viewModel);
    }
    viewModel.toggleEditMode();
  }

  @override
  void dispose() {
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

}
