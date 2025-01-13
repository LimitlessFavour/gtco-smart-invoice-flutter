import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import './firebase_options.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/repositories/auth_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/client_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/invoice_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/product_repository.dart';
import 'package:gtco_smart_invoice_flutter/screens/web/landing_screen.dart';
import 'package:gtco_smart_invoice_flutter/services/api_client.dart';
import 'package:gtco_smart_invoice_flutter/services/dio_client.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:gtco_smart_invoice_flutter/utils/image_precacher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/single_child_widget.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final navigationService = NavigationService();

  if (kIsWeb) {
    navigationService.initializeHistory();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      // builder: (context) => const ComingSoonScreen(),
      builder: (context) => AppRoot(navigationService: navigationService),
      // builder: (context) => AppRoot(navigationService: navigationService),
    ),
  );

  // runApp(const ComingSoonScreen());
}

//create a  stateless widget with scaffold which
//contains a centered text saying coming soon
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}


class AppRoot extends StatelessWidget {
  final NavigationService navigationService;

  const AppRoot({
    required this.navigationService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: _createProviders(),
      child: const SmartInvoiceApp(),
    );
  }

  List<SingleChildWidget> _createProviders() {
    final dioClient = DioClient(
      baseUrl: const String.fromEnvironment('API_BASE_URL'),
    );
    final authRepository = AuthRepository(dioClient);

    return [
      provider.ChangeNotifierProvider<NavigationService>.value(
          value: navigationService),
      provider.ChangeNotifierProvider(
        create: (_) => AuthProvider(authRepository),
      ),
      provider.Provider(
        create: (_) => ApiClient(
          baseUrl: const String.fromEnvironment('API_BASE_URL'),
        ),
      ),
      provider.Provider(
        create: (context) => InvoiceRepository(
          context.read<ApiClient>(),
        ),
      ),
      provider.ChangeNotifierProvider(
        create: (context) => InvoiceProvider(
          context.read<InvoiceRepository>(),
        ),
      ),
      provider.Provider(
        create: (context) => ProductRepository(
          context.read<ApiClient>(),
        ),
      ),
      provider.ChangeNotifierProvider(
        create: (context) => ProductProvider(
          context.read<ProductRepository>(),
        ),
      ),
      provider.Provider(
        create: (context) => ClientRepository(context.read<ApiClient>()),
      ),
      provider.ChangeNotifierProvider(
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
