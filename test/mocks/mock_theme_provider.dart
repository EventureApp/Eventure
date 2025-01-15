import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';

class MockThemeProvider extends Mock implements ChangeNotifier {
  bool _mockIsDarkMode = true;

  bool get isDarkMode => _mockIsDarkMode;

  void setMockIsDarkMode(bool isDarkMode) {
    _mockIsDarkMode = isDarkMode;
    notifyListeners();
  }

  void toggleTheme() {
    _mockIsDarkMode = !_mockIsDarkMode;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.noSuchMethod(
      Invocation.method(#notifyListeners, []),
    );
  }
}
