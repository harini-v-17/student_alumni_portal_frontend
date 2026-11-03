import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/alumni_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/welcome/welcome_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // AlumniProvider manages alumni list, search and domain filter state.
        ChangeNotifierProvider(create: (_) => AlumniProvider()),
        // AuthProvider manages login / logout state (prototype local auth).
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const StudentAlumniPortalApp(),
    ),
  );
}

class StudentAlumniPortalApp extends StatelessWidget {
  const StudentAlumniPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student–Alumni Portal',
      debugShowCheckedModeBanner: false,

      // Material 3 theme — navy primary, teal accent.
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // WelcomeScreen is the entry point; navigation flows outward from here.
      home: const WelcomeScreen(),
    );
  }
}
