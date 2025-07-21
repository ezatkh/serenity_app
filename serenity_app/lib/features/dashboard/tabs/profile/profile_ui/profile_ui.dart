import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity_app/features/dashboard/tabs/profile/profile_ui/widgets/custom_date_field.dart';
import 'package:serenity_app/features/dashboard/tabs/profile/profile_ui/widgets/custom_dropdown_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local/LocalizationService.dart';
import '../../../../../data/Models/account_profile.dart';
import '../../../../../widgets/custom_text_field.dart';
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

  AccountProfile? _profile;
  bool isEditing = false;
  bool isLoading = false;
  String? selectedGender;
  String? selectedClientManager;
  String? selectedCaseManager;


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
  final ProfileViewModel profileViewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    selectedGender = "Male";
    selectedClientManager = "Manager1";
    fetchAndFillProfile();
  }

  void fetchAndFillProfile() async {
    final data = await profileViewModel.fetchProfile(context);
    if (data == null) return;

    setState(() {
      _profile = data;
      nifController.text = _profile!.nif ?? '';
      nameController.text = _profile!.name ?? '';
      emailController.text = _profile!.email ?? '';
      dobController.text = _profile!.dateOfBirth ?? '';
      addressStreetController.text = _profile!.billingAddressStreet ?? '';
      addressCityController.text = _profile!.billingAddressCity ?? '';
      addressPostalCodeController.text = _profile!.billingAddressPostalCode ?? '';
      doorNumberController.text = _profile!.doorNumber ?? '';
      apartmentNumberController.text = _profile!.apartmentNumber ?? '';
      countryController.text = _profile!.countryOfOrigin ?? '';
      statusController.text = _profile!.status ?? '';
      joinDateController.text = _profile!.joinDate ?? '';
      emergencyConstantNameController.text = _profile!.emergencyContactName ?? '';
      emergencyConstantPhoneController.text = _profile!.emergencyContactPhone ?? '';

      selectedGender = genderOptions.contains(_profile!.gender)
          ? _profile!.gender
          : null;

      selectedClientManager = clientManagerOptions.contains(_profile!.clientManager)
          ? _profile!.clientManager
          : null;

      selectedCaseManager = caseManagerOptions.contains(_profile!.caseManager)
          ? _profile!.caseManager
          : null;
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.shortestSide / 375).clamp(1.0, 1.3);
    var appLocalization = Provider.of<LocalizationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
                          backgroundImage: AssetImage('assets/images/person.png'),
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
                        onChanged: (val) {
                          setState(() {
                            selectedGender = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: CustomDropdownField(
                        label: appLocalization.getLocalizedString("caseManager"),
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
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: CustomDropdownField(
                        label: appLocalization.getLocalizedString("clientManager"),
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
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: CustomTextField(
                        label: appLocalization.getLocalizedString("status"),
                        controller: statusController,
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
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 14 * scale),
                          ),
                          onPressed: () async {
                            if (isEditing) {
                              setState(() {
                                isLoading =true;
                              });
                              await profileViewModel.updateProfile(context,
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
                              );
                              setState(() {
                                isLoading =false;
                              });
                            }
                            setState(() {
                              isEditing = profileViewModel.toggleEditMode(isEditing);
                            });
                          },
                          child: Text(
                            isEditing ? appLocalization.getLocalizedString("save") :appLocalization.getLocalizedString("update"),
                            style: TextStyle(color: AppColors.white, fontSize: 15 * scale),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
