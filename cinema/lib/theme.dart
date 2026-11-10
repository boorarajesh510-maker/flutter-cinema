import 'package:flutter/material.dart';

const kBrand = Color(0xFFE50914);

ThemeData buildTheme(Brightness b) {
  final scheme = ColorScheme.fromSeed(seedColor: kBrand, brightness: b);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        b == Brightness.dark ? const Color(0xFF0E0E12) : const Color(0xFFF7F7FA),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

/// Number of grid columns for the current width (mobile / tablet / desktop).
int columnsFor(double width) =>
    width >= 1100 ? 5 : width >= 800 ? 4 : width >= 550 ? 3 : 2;
