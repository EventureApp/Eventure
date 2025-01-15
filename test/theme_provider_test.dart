//test/theme_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    late MockThemeProvider mockThemeProvider;

    setUp(() {
      mockThemeProvider = MockThemeProvider();
    });

    test('Should retrieve the initial theme mode', () {
      expect(mockThemeProvider.isDarkMode, true);
    });

    test('Should toggle theme mode', () {
      mockThemeProvider.toggleTheme();

      expect(mockThemeProvider.isDarkMode, false);

      mockThemeProvider.toggleTheme();
      expect(mockThemeProvider.isDarkMode, true);
    });

    test('Should set and retrieve custom theme mode', () {
      mockThemeProvider.setMockIsDarkMode(false);

      expect(mockThemeProvider.isDarkMode, false);

      mockThemeProvider.setMockIsDarkMode(true);

      expect(mockThemeProvider.isDarkMode, true);
    });
  });
}
