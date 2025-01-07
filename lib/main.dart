import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtco_smart_invoice_flutter/layouts/web_main_layout.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/repositories/client_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/invoice_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/product_repository.dart';
import 'package:gtco_smart_invoice_flutter/services/api_client.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:gtco_smart_invoice_flutter/utils/image_precacher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

void main() {
  // Initialize navigation history for web
  if (kIsWeb) {
    NavigationService().initializeHistory();
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationService()),
        Provider(
          create: (_) => ApiClient(baseUrl: 'https://api.example.com'),
        ),
        Provider(
          create: (context) => InvoiceRepository(
            context.read<ApiClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => InvoiceProvider(
            context.read<InvoiceRepository>(),
          ),
        ),
        // Product providers
        Provider(
          create: (context) => ProductRepository(
            context.read<ApiClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductRepository>(),
          ),
        ),
        Provider(
          create: (context) => ClientRepository(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientProvider(context.read<ClientRepository>()),
        ),
      ],
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
          seedColor: const Color(0xFFE04403),
          primary: const Color(0xFFE04403),
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
            borderSide: const BorderSide(color: Color(0xFFE04403)),
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
      home: const AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await ImagePrecacher.precacheImages(context);
    // Add any other initialization tasks here
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // return const LandingScreen();
          // Replace with your actual initial screen
          return const WebMainLayout();
        }
        // Show a loading screen while precaching
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ),
          ),
        );
      },
    );
  }
}
