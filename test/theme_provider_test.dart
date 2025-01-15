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
      // Assert
      expect(mockThemeProvider.isDarkMode, true);
    });

    test('Should toggle theme mode', () {
      // Act
      mockThemeProvider.toggleTheme();

      // Assert
      expect(mockThemeProvider.isDarkMode, false);

      // Toggle back
      mockThemeProvider.toggleTheme();
      expect(mockThemeProvider.isDarkMode, true);
    });

    test('Should set and retrieve custom theme mode', () {
      // Arrange
      mockThemeProvider.setMockIsDarkMode(false);

      // Assert
      expect(mockThemeProvider.isDarkMode, false);

      // Arrange
      mockThemeProvider.setMockIsDarkMode(true);

      // Assert
      expect(mockThemeProvider.isDarkMode, true);
    });
  });
}
