import 'package:flutter/material.dart';
import '../../../../../core/services/api/appointments_api_service.dart';
import '../../../../../core/services/api/profile_api_service.dart';
import '../../../data/Models/account_profile.dart';
import '../../../data/Models/appointments_model.dart';
import '../../../core/services/cache/sharedPreferences.dart';
import '../../../core/constants/constants.dart';

class HomeViewModel extends ChangeNotifier {
  bool _profileLoading = false;
  bool get profileLoading => _profileLoading;

  bool _appointmentLoading = false;
  bool get appointmentLoading => _appointmentLoading;

  AccountProfile? _profile;
  AccountProfile? get profile => _profile;

  AppointmentModel? _nextAppointment;
  AppointmentModel? get nextAppointment => _nextAppointment;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _profileLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);
      if (accountId == null || accountId.isEmpty) {
        _errorMessage = 'No account ID found';
        return;
      }

      final response = await ProfileApiService.getAccountDetail(accountId: accountId);
        final status = response['status'];
        final data = response['data'];
        if (status == 200 && data != null) {
          _profile = AccountProfile.fromJson(data);
        } else {
          _errorMessage = response['error'] ?? 'Failed to load profile';
        }
    } catch (e) {
      _errorMessage = 'Failed to load profile';
      debugPrint(e.toString());
    } finally {
      _profileLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextAppointment() async {
    _appointmentLoading = true;
    _errorMessage = null;
    _nextAppointment = null; // reset previous appointment
    notifyListeners();

    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);
      if (accountId == null || accountId.isEmpty) {
        _errorMessage = 'No account ID found';
        return;
      }

      final response = await AppointmentsApiService.getAppointments(accountId: accountId);
       final status = response['status'];
       final data = response['data'];

        if (status == 200 && data != null) {
          final List<dynamic> list = data['list'] ?? [];

          if (list.isEmpty) {
            _nextAppointment = null;
          } else {
            List<AppointmentModel> appointments = list
                .map((json) => AppointmentModel.fromJson(json))
                .toList();

            final now = DateTime.now();
            final upcomingAppointments = appointments.where((appointment) {
              if (appointment.dateStart == null) return false;
              final date = DateTime.tryParse(appointment.dateStart!);
              return date != null && date.isAfter(now);
            }).toList();

            upcomingAppointments.sort((a, b) {
              final dateA = DateTime.tryParse(a.dateStart!)!;
              final dateB = DateTime.tryParse(b.dateStart!)!;
              return dateA.compareTo(dateB);
            });

            _nextAppointment =
            upcomingAppointments.isNotEmpty ? upcomingAppointments.first : null;
          }
        } else {
          _errorMessage = response['error'] ?? 'Failed to load appointments';
        }
    } catch (e) {
      _errorMessage = 'Failed to load appointment';
      debugPrint(e.toString());
    } finally {
      _appointmentLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHomeData() async {
    _errorMessage = null;
    notifyListeners();

    await Future.wait([
      fetchProfile(),
      fetchNextAppointment(),
    ]);
  }
}