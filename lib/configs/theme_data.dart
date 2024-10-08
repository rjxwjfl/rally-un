import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  fontFamily: 'Pretendard',
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  fontFamily: 'Pretendard',
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006699), // Primary Blue
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFB3E5FC), // Light Blue Container
  onPrimaryContainer: Color(0xFF001F33),
  secondary: Color(0xFF6699CC), // Secondary Blue
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCCCFF2), // Light Purple-Blue Container
  onSecondaryContainer: Color(0xFF2A3A72),
  tertiary: Color(0xFF80C1FF), // Tertiary Blue
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD1C4E9), // Light Purple-Blue Container
  onTertiaryContainer: Color(0xFF311B92),
  error: Color(0xFFB00020),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD4),
  onErrorContainer: Color(0xFF37000B),
  background: Color(0xFFF5F5F5),
  onBackground: Color(0xFF001F33),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF001F33),
  surfaceVariant: Color(0xFFDDEEFF),
  onSurfaceVariant: Color(0xFF001F33),
  outline: Color(0xFF737373),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF333333),
  onInverseSurface: Color(0xFFE0E0E0),
  inversePrimary: Color(0xFF80C1FF),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF80C1FF), // Primary Blue
  onPrimary: Color(0xFF00334D),
  primaryContainer: Color(0xFF004C99), // Dark Blue Container
  onPrimaryContainer: Color(0xFFB3E5FC),
  secondary: Color(0xFF6699CC), // Secondary Blue
  onSecondary: Color(0xFF00334D),
  secondaryContainer: Color(0xFF7E57C2), // Dark Purple-Blue Container
  onSecondaryContainer: Color(0xFFF3E5F5), // Light Purple-Blue
  tertiary: Color(0xFF80C1FF), // Tertiary Blue
  onTertiary: Color(0xFF00334D),
  tertiaryContainer: Color(0xFF5C6BC0), // Dark Purple-Blue Container
  onTertiaryContainer: Color(0xFFE8EAF6), // Light Purple-Blue
  error: Color(0xFFCF6679),
  onError: Color(0xFF37000B),
  errorContainer: Color(0xFFB00020),
  onErrorContainer: Color(0xFFFFDAD4),
  background: Color(0xFF121212), // Darker Background
  onBackground: Color(0xFFE0E0E0),
  surface: Color(0xFF1E1E1E), // Darker surface
  onSurface: Color(0xFFE0E0E0),
  surfaceVariant: Color(0xFF2C2C2C), // Slightly lighter surface variant
  onSurfaceVariant: Color(0xFFE0E0E0),
  outline: Color(0xFF737373),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE0E0E0),
  onInverseSurface: Color(0xFF2A2A2A),
  inversePrimary: Color(0xFF80C1FF),
);
