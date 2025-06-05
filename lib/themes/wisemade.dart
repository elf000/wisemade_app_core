import 'package:flutter/material.dart';

// Cores - constantes no padrão lowerCamelCase
const primaryColor = Color(0xff230346);
const primaryColorLight = Color(0xff230346);
const primaryColorDark = Color(0xFF10101A);

const secondaryColor = Color(0xff50ff9b);
const secondaryColorLight = Color(0xFFe5ffff);
const secondaryColorDark = Color(0xFF82ada9);

const accentColor = Color(0xFF763BF1);

// Dark Theme
const backgroundDark = Color(0xFF121225);
const accentBackgroundDark = Color(0xff1a1931);
const textColorDark = Color(0xFFffffff);
const secondaryTextColorDark = Color(0xFFcccccc);

// Light Theme
const backgroundLight = Color(0xfff1f1f1);
const accentBackgroundLight = Color(0xfff7f7f7);
const textColorLight = Color(0xFF222222);

class WisemadeTheme {
  static final ThemeData darkTheme = _buildDarkTheme();
  static final ThemeData lightTheme = _buildLightTheme();

  static ThemeData _buildDarkTheme() {
    final base = ThemeData.dark();

    return base.copyWith(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: secondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
        color: accentColor,
      ),

      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        labelStyle: const TextStyle(color: Colors.white),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          minimumSize: const Size.fromHeight(60),
          textStyle: const TextStyle(fontSize: 16),
          foregroundColor: primaryColor,
          disabledBackgroundColor: accentBackgroundDark.withAlpha(100),
          disabledForegroundColor: Colors.white54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),

      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(color: textColorDark),
        headlineSmall: const TextStyle(fontSize: 24, color: textColorDark),
        titleLarge: const TextStyle(fontSize: 18, color: textColorDark),
      ),

      dividerTheme: base.dividerTheme.copyWith(
        color: accentBackgroundDark,
        thickness: 1,
      ),

      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: accentColor, width: 2),
          ),
        ),
      ),

      datePickerTheme: base.datePickerTheme.copyWith(
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(textColorDark),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(textColorDark),
        ),
        dividerColor: textColorDark,
      ),

      scaffoldBackgroundColor: backgroundDark,
      cardColor: accentBackgroundDark,

      colorScheme: base.colorScheme.copyWith(
        outline: textColorDark,
        shadow: Colors.white70,
        error: Colors.redAccent[700],
        primaryContainer: accentBackgroundDark,
        surface: backgroundDark, // substitui 'background'
        primary: primaryColor,
        secondary: accentColor,
        tertiary: secondaryColor,
      ),
    );
  }

  static ThemeData _buildLightTheme() {
    final base = ThemeData.light();

    return base.copyWith(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: secondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(color: textColorLight),
        headlineSmall: const TextStyle(fontSize: 24, color: textColorLight),
        titleLarge: const TextStyle(fontSize: 18, color: textColorLight),
      ),

      scaffoldBackgroundColor: backgroundLight,
      cardColor: accentBackgroundLight,

      colorScheme: base.colorScheme.copyWith(
        outline: textColorLight,
        shadow: textColorLight,
        primaryContainer: accentBackgroundDark,
        surface: backgroundLight, // substitui 'background'
      ),
    );
  }
}