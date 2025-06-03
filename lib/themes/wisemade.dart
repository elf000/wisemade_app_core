import 'package:flutter/material.dart';

const PrimaryColor = Color(0xff230346);
const PrimaryColorLight = Color(0xff230346);
const PrimaryColorDark = Color(0xFF10101A);

const SecondaryColor = Color(0xff50ff9b);
const SecondaryColorLight = Color(0xFFe5ffff);
const SecondaryColorDark = Color(0xFF82ada9);

const AccentColor = Color(0xFF763BF1);

// Dark Colors
const BackgroundDark = Color(0xFF121225);
const AccentBackgroundDark = Color(0xff1a1931);
const TextColorDark = Color(0xFFffffff);
const SecondaryTextColorDark = Color(0xFFcccccc);

// Light Colors
const BackgroundLight = Color(0xfff1f1f1);
const AccentBackgroundLight = Color(0xfff7f7f7);
const TextColorLight = Color(0xFF222222);

class WisemadeTheme {
  static final ThemeData darkTheme = _buildDarkTheme();
  static final ThemeData lightTheme = _buildLightTheme();


  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
        color: AccentColor,
      ),

      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white38), borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AccentColor), borderRadius: BorderRadius.all(Radius.circular(5))),
        labelStyle: const TextStyle(color: Colors.white),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        )
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SecondaryColor,
          minimumSize: const Size.fromHeight(60),
          textStyle: const TextStyle(fontSize: 16),
          foregroundColor: PrimaryColor,
          disabledBackgroundColor: AccentBackgroundDark.withAlpha(100),
          disabledForegroundColor: Colors.white54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )
        )
      ),

      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(color: TextColorDark),
        headlineSmall: const TextStyle(fontSize: 24, color: TextColorDark),
        titleLarge: const TextStyle(fontSize: 18, color: TextColorDark),
      ),

      dividerTheme: base.dividerTheme.copyWith(
        color: AccentBackgroundDark,
        thickness: 1
      ),


      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AccentColor,
              width: 2
            )
          )
        )
      ),

      datePickerTheme: base.datePickerTheme.copyWith(
        cancelButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all(TextColorDark)),
        confirmButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all(TextColorDark)),
        dividerColor: TextColorDark,
      ),

      scaffoldBackgroundColor: BackgroundDark,
      cardColor: AccentBackgroundDark,
      colorScheme: base.colorScheme.copyWith(
        outline: TextColorDark,
        shadow: Colors.white70,
        error: Colors.redAccent[700],
        primaryContainer: AccentBackgroundDark,
        background: BackgroundDark,
        primary: PrimaryColor,
        secondary: AccentColor,
        tertiary: SecondaryColor,
      )
    );
  }

  static ThemeData _buildLightTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(color: TextColorLight),
        headlineSmall: const TextStyle(fontSize: 24, color: TextColorLight),
        titleLarge: const TextStyle(fontSize: 18, color: TextColorLight),
      ),

      scaffoldBackgroundColor: BackgroundLight,
      cardColor: AccentBackgroundLight,
      colorScheme: base.colorScheme.copyWith(
        outline: TextColorLight,
        shadow: TextColorLight,
        primaryContainer: AccentBackgroundDark
      ).copyWith(background: BackgroundLight)
    );
  }
}
