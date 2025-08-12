import 'package:flutter/material.dart';
import 'package:serenity_app/features/profile/profile_ui/widgets/custom_date_field.dart';
import 'package:serenity_app/features/profile/profile_ui/widgets/custom_dropdown_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/local/LocalizationService.dart';
import '../../../../widgets/custom_text_field.dart';


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