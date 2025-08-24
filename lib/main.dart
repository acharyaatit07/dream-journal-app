// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/dreams/screens/dreams_home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DreamJournalApp(),
    ),
  );
}

class DreamJournalApp extends StatelessWidget {
  const DreamJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DreamsHomeScreen(),
    );
  }
}
