import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../profile/profile_viewmodel/profile_viewmodel.dart';

class DashboardViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> changeTab(BuildContext context, int index) async {
    if (index == 2) {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

      if (!profileVM.isLoaded && !profileVM.isLoading) {
        await profileVM.fetchProfile(context);
      }
    }

    _currentIndex = index;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void clear() {
    _currentIndex = 0;
    notifyListeners();
  }
}
