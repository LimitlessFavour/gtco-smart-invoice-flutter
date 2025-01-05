import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtco_smart_invoice_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:gtco_smart_invoice_flutter/screens/help/help_center_screen.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_list_screen.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/settings_screen.dart';
import 'package:gtco_smart_invoice_flutter/screens/web/landing_screen.dart';
import 'package:provider/provider.dart';
import 'services/navigation_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavigationService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GTCO Smart Invoice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE84C3D),
          primary: const Color(0xFFE84C3D),
        ),
        textTheme: GoogleFonts.urbanistTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE84C3D)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationService>(
      builder: (context, navigation, _) {
        return _buildScreen(navigation.currentScreen);
      },
    );
  }

  Widget _buildScreen(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return const DashboardScreen();
      case AppScreen.invoice:
        return const InvoiceListScreen();
      case AppScreen.product:
        return const Center(child: Text('Product Screen - Coming Soon'));
      case AppScreen.client:
        return const Center(child: Text('Client Screen - Coming Soon'));
      case AppScreen.settings:
        return const SettingsScreen();
      case AppScreen.helpCenter:
        return const HelpCenterScreen();
    }
  }
}
