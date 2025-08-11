import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/profile/profile_ui/widgets/custom_date_field.dart';
import 'package:serenity_app/features/profile/profile_ui/widgets/custom_dropdown_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../../../data/Models/account_profile.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/loading_dialog.dart';
import '../profile_viewmodel/profile_viewmodel.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
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
      dobController.text = profile.dateOfBirth ?? '';
      addressStreetController.text = profile.billingAddressStreet ?? '';
      addressCityController.text = profile.billingAddressCity ?? '';
      addressPostalCodeController.text = profile.billingAddressPostalCode ?? '';
      doorNumberController.text = profile.doorNumber ?? '';
      apartmentNumberController.text = profile.apartmentNumber ?? '';
      countryController.text = profile.countryOfOrigin ?? '';
      caseManagerController.text = profile.caseManager ?? '';
      clientManagerController.text = profile.clientManager ?? '';
      phoneController.text = profile.phoneNumber ?? '';

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
    if (viewModel.isEditing) {
      LoadingDialog.show(context);
      await viewModel.updateProfile(
        context,
        dobController: dobController,
        addressStreetController: addressStreetController,
        addressCityController: addressCityController,
        addressPostalCodeController: addressPostalCodeController,
        doorNumberController: doorNumberController,
        apartmentNumberController: apartmentNumberController,
        gender: selectedGender!,
        emailController: emailController,
        countryController: countryController,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    final appLocalization = Provider.of<LocalizationService>(context, listen: false);

    return Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          final isEditing = profileViewModel.isEditing;
          final isLoading = profileViewModel.isLoading;

          return Scaffold(
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
                            onSaveOrUpdate: () => _handleProfileEditOrUpdate(profileViewModel),
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
          );
        }
    );
  }

}


class BodyFields extends StatelessWidget {
  final bool isEditing;
  final double scale;
  final LocalizationService appLocalization;
  final TextEditingController nifController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController emergencyConstantNameController;
  final TextEditingController emergencyConstantPhoneController;
  final TextEditingController dobController;
  final TextEditingController joinDateController;
  final TextEditingController addressStreetController;
  final TextEditingController addressCityController;
  final TextEditingController addressPostalCodeController;
  final TextEditingController doorNumberController;
  final TextEditingController apartmentNumberController;
  final TextEditingController countryController;
  final String? selectedGender;
  final List<String> genderOptions;
  final Function(String?) onGenderChanged;
  final TextEditingController caseManagerController;
  final TextEditingController clientManagerController;
  final TextEditingController statusController;
  final VoidCallback onSaveOrUpdate;

  const BodyFields({
    Key? key,
    required this.isEditing,
    required this.scale,
    required this.appLocalization,
    required this.nifController,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.emergencyConstantNameController,
    required this.emergencyConstantPhoneController,
    required this.dobController,
    required this.joinDateController,
    required this.addressStreetController,
    required this.addressCityController,
    required this.addressPostalCodeController,
    required this.doorNumberController,
    required this.apartmentNumberController,
    required this.countryController,
    required this.selectedGender,
    required this.genderOptions,
    required this.onGenderChanged,
    required this.caseManagerController,
    required this.clientManagerController,
    required this.statusController,
    required this.onSaveOrUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: CustomTextField(
              label: appLocalization.getLocalizedString("nif"),
              controller: nifController,
              scale: scale,
              labelColor: AppColors.greyLabelText,
              enabled: isEditing,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("name"),
            controller: nameController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("email"),
            controller: emailController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: CustomTextField(
              label: appLocalization.getLocalizedString("mobile"),
              controller: phoneController,
              scale: scale,
              labelColor: AppColors.greyLabelText,
              enabled: isEditing,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("emergencyContactName"),
            controller: emergencyConstantNameController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("emergencyContactPhone"),
            controller: emergencyConstantPhoneController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomDateField(
            label: appLocalization.getLocalizedString("dateOfBirth"),
            controller: dobController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: CustomDateField(
              label: appLocalization.getLocalizedString("joinDate"),
              controller: joinDateController,
              scale: scale,
              labelColor: AppColors.greyLabelText,
              enabled: isEditing,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("addressStreet"),
            controller: addressStreetController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("addressCity"),
            controller: addressCityController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("addressPostal"),
            controller: addressPostalCodeController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("doorNumber"),
            controller: doorNumberController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("apartment"),
            controller: apartmentNumberController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomTextField(
            label: appLocalization.getLocalizedString("countryOfOrigin"),
            controller: countryController,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CustomDropdownField(
            label: appLocalization.getLocalizedString("gender"),
            selectedValue: selectedGender,
            items: genderOptions,
            scale: scale,
            labelColor: AppColors.greyLabelText,
            enabled: isEditing,
            onChanged: onGenderChanged,
          ),
        ),
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: CustomTextField(
              label: appLocalization.getLocalizedString("caseManager"),
              controller: caseManagerController,
              scale: scale,
              labelColor: AppColors.greyLabelText,
              enabled: false,
            ),
          ),
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: CustomTextField(
              label: appLocalization.getLocalizedString("clientManager"),
              controller: clientManagerController,
              scale: scale,
              labelColor: AppColors.greyLabelText,
              enabled: false,
            ),
          ),
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: CustomTextField(
              label: appLocalization.getLocalizedString("status"),
              controller: statusController,
              scale: scale,
              labelColor: AppColors.greyLabelText,
              enabled: false,
            ),
          ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 14 * scale),
              ),
              onPressed: onSaveOrUpdate,
              child: Text(
                isEditing
                    ? appLocalization.getLocalizedString("save")
                    : appLocalization.getLocalizedString("update"),
                style: TextStyle(color: AppColors.white, fontSize: 15 * scale),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
