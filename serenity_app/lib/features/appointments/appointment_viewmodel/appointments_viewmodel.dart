import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/api/appointments_api_service.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../data/Models/appointments_model.dart';

class AppointmentsViewModel extends ChangeNotifier {
  List<AppointmentModel> appointments = [];
  AppointmentModel? selectedAppointment;
  bool isLoading = false;
  String? errorMessage;
  bool _hasFetched = false;

  void resetFetched() {
    _hasFetched = false;
  }

  void selectAppointment(AppointmentModel appointmentItem) {
    selectedAppointment = appointmentItem;
    notifyListeners();
  }

  Future<void> fetchAppointments(BuildContext context) async {
    if (_hasFetched || isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);

      if (accountId == null || accountId.isEmpty) {
        errorMessage = 'No accountId found in Shared Preferences';
        ToastService.show(message: errorMessage!, type: ToastType.error);
        return;
      }

      final response = await AppointmentsApiService.getAppointments(accountId: accountId);

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        try {
          final List<dynamic> list = data['list'] ?? [];
          appointments = list.map((json) => AppointmentModel.fromJson(json)).toList();
          _hasFetched = true;
        } catch (e) {
          errorMessage = 'Error parsing appointments data: $e';
          ToastService.show(message: errorMessage!, type: ToastType.error);
        }
      } else {
        errorMessage = response['error'] ?? 'Something went wrong';
        ToastService.show(message: errorMessage!, type: ToastType.error);
      }
    } catch (e) {
      // Catch exceptions like network errors here
      errorMessage = 'Failed to fetch appointments: $e';
      ToastService.show(message: errorMessage!, type: ToastType.error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    appointments = [];
    selectedAppointment = null;
    isLoading = false;
    errorMessage = null;
    _hasFetched = false;
    notifyListeners();
  }
}
