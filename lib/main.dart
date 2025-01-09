import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtco_smart_invoice_flutter/firebase_options.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/repositories/client_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/invoice_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/product_repository.dart';
import 'package:gtco_smart_invoice_flutter/screens/web/landing_screen.dart';
import 'package:gtco_smart_invoice_flutter/services/api_client.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:gtco_smart_invoice_flutter/utils/image_precacher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    NavigationService().initializeHistory();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _createProviders(),
      child: const SmartInvoiceApp(),
    );
  }

  List<SingleChildWidget> _createProviders() {
    return [
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
    ];
  }
}

class SmartInvoiceApp extends StatelessWidget {
  const SmartInvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GTCO Smart Invoice',
      theme: _buildAppTheme(context),
      debugShowCheckedModeBanner: false,
      home: const AppInitializationWrapper(),
    );
  }

  ThemeData _buildAppTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE04403),
        primary: const Color(0xFFE04403),
      ),
      textTheme: GoogleFonts.urbanistTextTheme(
        Theme.of(context).textTheme,
      ),
      useMaterial3: true,
      inputDecorationTheme: _buildInputDecorationTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
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
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class AppInitializationWrapper extends StatefulWidget {
  const AppInitializationWrapper({super.key});

  @override
  State<AppInitializationWrapper> createState() =>
      _AppInitializationWrapperState();
}

class _AppInitializationWrapperState extends State<AppInitializationWrapper> {
  late final Future<void> _initFuture;

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
          return const LandingScreen();
        }
        return _buildLoadingScreen();
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Theme.of(context).primaryColor,
          size: 50,
        ),
      ),
    );
  }
}
