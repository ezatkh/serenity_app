import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/api/profile_api_service.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../../../data/Models/account_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isEditing = false;
  AccountProfile? _profile;
  bool _isLoading = false;

  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  AccountProfile? get profile => _profile;

  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<AccountProfile?> fetchProfile(BuildContext context) async {
    _setLoading(true);

    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);

      if (accountId == null || accountId.isEmpty) {
        debugPrint('No accountId found in Shared Preferences');
        return null;
      }

      final response = await ProfileApiService.getAccountDetail(
        accountId: accountId,
      );

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        _profile = AccountProfile.fromJson(data);
        notifyListeners();
        return _profile;
      } else {
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
      }
    } catch (e, stacktrace) {
      debugPrint("Exception in fetchProfile: $e");
      debugPrint("Stacktrace: $stacktrace");

      ToastService.show(
        message: 'Unexpected error occurred :${e}',
        type: ToastType.error,
      );
    }
    finally {
      _setLoading(false);
    }

    return null;
  }

  Future<void> updateProfile(BuildContext context, {
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
    required TextEditingController nifController,
  }) async {
    try {
      _setLoading(true);

      final accountId = await SharedPrefsUtil.getString(USER_ID);
      if (accountId == null || accountId.isEmpty) {
        debugPrint('No accountId found in Shared Preferences');
        return;
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
        nif: nifController.text.trim(),
        gender: 'Male',
      );

      debugPrint("Updating profile with:");
      debugPrint(profile.toString());

      final response = await ProfileApiService.updateAccountDetail(
        accountId: accountId,
        body: profile.toJson(),
      );

      final status = response['status'];

      if (status == 200) {
        ToastService.show(
          message: 'Profile updated successfully',
          type: ToastType.success,
        );
      } else {
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in updateProfile: $e');
      debugPrint('Stack trace: $stackTrace');
      ToastService.show(
        message: 'Unexpected error occurred while updating profile.',
        type: ToastType.error,
      );
    }
    finally {
      _setLoading(false);
    }
  }


}
