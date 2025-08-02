import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/services/api/cases_api_service.dart';
import '../../../../../core/services/cache/sharedPreferences.dart';
import '../../../../../core/services/local/toast_service.dart';
import '../../../data/Models/cases_model.dart';

class CasesViewModel extends ChangeNotifier {
  List<CaseModel> cases = [];
  CaseModel? selectedCase;
  bool isLoading = false;
  String? errorMessage;
  bool _hasFetched = false;

  void resetFetched() {
    _hasFetched = false;
  }

  void selectCase(CaseModel caseItem) {
    selectedCase = caseItem;
    notifyListeners();
  }

  Future<void> fetchCases(BuildContext context) async {
    if (_hasFetched) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final accountId = await SharedPrefsUtil.getString(USER_ID);

    if (accountId == null || accountId.isEmpty) {
      errorMessage = 'No accountId found in Shared Preferences';
      isLoading = false;
      notifyListeners();
      return;
    }

    final response = await CasesApiService.getCases(
      accountId: accountId,
    );

    final status = response['status'];
    final data = response['data'];

    if (status == 200 && data != null) {
      try {
        final List<dynamic> list = data['list'] ?? [];
        cases = list.map((json) => CaseModel.fromJson(json)).toList();
        print('Fetched cases count: ${cases.length}');
        for (var c in cases) {
          print('Case: ${c.id} - ${c.name} - Status: ${c.status}');
        }
      } catch (e) {
        errorMessage = 'Error parsing cases data: $e';
        print(errorMessage);
      }
    } else {
      errorMessage = response['error'] ?? 'Something went wrong';
      print(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }
}
