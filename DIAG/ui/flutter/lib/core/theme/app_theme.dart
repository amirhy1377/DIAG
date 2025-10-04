import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const seed = Color(0xFF0D47A1);
  final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: Typography.englishLike2021.apply(fontFamily: 'Roboto'),
  );
}

ThemeData buildDarkTheme() {
  const seed = Color(0xFF82B1FF);
  final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: Typography.englishLike2021.apply(fontFamily: 'Roboto'),
  );
}
