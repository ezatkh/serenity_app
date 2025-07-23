import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/api/profile_api_service.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../../../data/Models/account_profile.dart';

class ProfileViewModel {
  bool toggleEditMode(bool currentEditing) {
    return !currentEditing;
  }

  Future<AccountProfile?> fetchProfile(BuildContext context) async {
    final accountId =  await SharedPrefsUtil.getString(USER_ID);

    if (accountId == null || accountId.isEmpty) {
      debugPrint('No accountId found in Shared Preferences');
      return null;
    }
    final response = await ProfileApiService.getAccountDetail(
      accountId: accountId,
      context: context,
    );

    final status = response['status'];
    final data = response['data'];
    if (status == 200 && data != null) {
      try {
        return AccountProfile.fromJson(data);
      } catch (e) {
        debugPrint("Error parsing profile data: $e");
        return null;
      }
    }
    else {
      ToastService.show(
        message: response['error'] ?? 'Something went wrong',
        type: ToastType.error,
      );
    }

    return null;
  }

  Future<void> updateProfile(BuildContext context,{
    required TextEditingController dobController,
    required TextEditingController addressStreetController,
    required TextEditingController addressCityController,
    required TextEditingController addressPostalCodeController,
    required TextEditingController doorNumberController,
    required TextEditingController apartmentNumberController,
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController statusController,
    required TextEditingController countryController,
    required TextEditingController emergencyConstantNameController,
    required TextEditingController emergencyConstantPhoneController,
  }) async {

    final accountId = await SharedPrefsUtil.getString(USER_ID);
    if (accountId == null || accountId.isEmpty) {
      debugPrint('No accountId found in Shared Preferences');
      return ;
    }

    final profile = AccountProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      dateOfBirth: dobController.text.trim(),
      billingAddressStreet: addressStreetController.text.trim(),
      billingAddressCity: addressCityController.text.trim(),
      billingAddressPostalCode: addressPostalCodeController.text.trim(),
      doorNumber: doorNumberController.text.trim(),
      apartmentNumber: apartmentNumberController.text.trim(),
      countryOfOrigin: countryController.text.trim(),
      emergencyContactName: emergencyConstantNameController.text.trim(),
      emergencyContactPhone: emergencyConstantPhoneController.text.trim(),
      status: statusController.text.trim(),
      // clientManager: '',
      // caseManager: '',
      gender: 'Male',
    );

    debugPrint("Updating profile with:");
    debugPrint(profile.toString());

    final response = await ProfileApiService.updateAccountDetail(
      accountId: accountId,
      body: profile.toJson(),
      context: context,
    );
    final status = response['status'];
    final data = response['data'];
    if (status == 200) {
      ToastService.show(
        message: 'profile updated successfully',
        type: ToastType.success,
      );
    }
    else {
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
    }
  }

}
