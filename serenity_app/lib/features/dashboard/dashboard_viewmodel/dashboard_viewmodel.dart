import 'package:flutter/foundation.dart';

class DashboardViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  final List<int> hiddenIndexes;

  DashboardViewModel({this.hiddenIndexes = const [4]});

  int get currentIndex => _currentIndex;

  int get navBarIndex {
    if (hiddenIndexes.contains(_currentIndex)) return -1;
    return _currentIndex;
  }

  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void openHiddenScreen(int index) {
    if (!hiddenIndexes.contains(index)) {
      throw Exception('Index $index is not registered as hidden screen');
    }
    setCurrentIndex(index);
  }
}
