import 'package:portfolio/infrastructure/theme/colors.dart';
import 'package:flutter/material.dart';

final ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: KColor.secondaryColor,
  secondaryHeaderColor: KColor.darkGrey,
  scaffoldBackgroundColor: KColor.darkScaffold,
  fontFamily: 'Poppins',
  fontFamilyFallback: ['Poppins'],
);
