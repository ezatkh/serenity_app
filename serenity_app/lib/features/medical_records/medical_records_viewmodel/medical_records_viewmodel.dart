import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../core/services/api/medical_record_service.dart';
import '../../../data/Models/medical_report_model.dart';

class MedicalRecordsViewModel extends ChangeNotifier {
  List<MedicalRecordModel> medicalRecords = [];
  MedicalRecordModel? selectedMedicalRecord;
  bool isLoading = false;
  String? errorMessage;
  bool _hasFetched = false;

  void resetFetched() {
    _hasFetched = false;
  }

  void selectMedicalRecord(MedicalRecordModel medicalRecordItem) {
    selectedMedicalRecord = medicalRecordItem;
    notifyListeners();
  }

  Future<void> fetchMedicalRecords(BuildContext context) async {
    if (_hasFetched || isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final accountId = await SharedPrefsUtil.getString(USER_ID);

      if (accountId == null || accountId.isEmpty) {
        errorMessage = 'No accountId found';
        ToastService.show(message: errorMessage!, type: ToastType.error);
        return;
      }

      final response = await MedicalRecordsApiService.getMedicalRecords(accountId: accountId);

      final status = response['status'];
      final data = response['data'];

      if (status == 200 && data != null) {
        try {
          final List<dynamic> list = data['list'] ?? [];
          medicalRecords = list.map((json) => MedicalRecordModel.fromJson(json)).toList();
          _hasFetched = true;
        } catch (e) {
          errorMessage = 'Error parsing Medical Records data: $e';
          ToastService.show(message: errorMessage!, type: ToastType.error);
        }
      } else {
        errorMessage = response['error'] ?? 'Something went wrong';
        ToastService.show(message: errorMessage!, type: ToastType.error);
      }
    } catch (e) {
      errorMessage = 'Failed to fetch medical Records: $e';
      ToastService.show(message: errorMessage!, type: ToastType.error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}