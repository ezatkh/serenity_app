import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/api/profile_api_service.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../../../data/Models/account_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  AccountProfile? _profile;
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isLoaded = false;

  bool get isEditing => _isEditing;
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  AccountProfile? get profile => _profile;

  void setEditing(bool value) {
    if (_isEditing != value) {
      _isEditing = value;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  Future<AccountProfile?> fetchProfile(BuildContext context, {bool forceRefresh = false}) async {
    if (_isLoaded && !forceRefresh) return _profile;
    setLoading(true);
    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);

      if (accountId == null || accountId.isEmpty) {
        debugPrint('No accountId found in Shared Preferences');
        setLoading(false);
        return null;
      }

      final response = await ProfileApiService.getAccountDetail(
        accountId: accountId,
      );

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        _profile = AccountProfile.fromJson(data);
        setLoaded(true);
        return _profile;
      } else {
        setLoaded(false);
        ToastService.show(
          message: response['error'] ?? 'Something went wrong',
          type: ToastType.error,
        );
      }
    } catch (e) {
      setLoaded(false);
      debugPrint("Exception in fetchProfile: $e");

      ToastService.show(
        message: 'Unexpected error occurred :$e',
        type: ToastType.error,
      );
    }
    finally {
      setLoading(false);
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
    required TextEditingController countryController,
    required String gender,
  }) async {
    try {
      setLoading(true);

      final accountId = await SharedPrefsUtil.getString(USER_ID);
      if (accountId == null || accountId.isEmpty) {
        debugPrint('No accountId found in Shared Preferences');
        return;
      }

      final profile = AccountProfile(
        email: emailController.text.trim(),
        countryOfOrigin: countryController.text.trim(),
        gender: gender,
        doorNumber: doorNumberController.text.trim(),
        billingAddressStreet: addressStreetController.text.trim(),
        billingAddressCity: addressCityController.text.trim(),
        billingAddressPostalCode: addressPostalCodeController.text.trim(),
        apartmentNumber: apartmentNumberController.text.trim(),
        dateOfBirth: dobController.text.trim(),
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
      setLoading(false);
    }
  }


}
