import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtco_smart_invoice_flutter/layouts/main_layout.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/dashboard_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/onboarding_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/repositories/auth_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/client_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/dashboard_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/invoice_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/onboarding_repository.dart';
import 'package:gtco_smart_invoice_flutter/repositories/product_repository.dart';
import 'package:gtco_smart_invoice_flutter/screens/web/landing_screen.dart';
import 'package:gtco_smart_invoice_flutter/services/api_client.dart';
import 'package:gtco_smart_invoice_flutter/services/dio_client.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:gtco_smart_invoice_flutter/utils/image_precacher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './firebase_options.dart';

// Define constants for environment variables
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debug environment variables
  if (kDebugMode) {
    print('\nEnvironment Variables:');
    print('API_BASE_URL: $apiBaseUrl');
    print('SUPABASE_URL: $supabaseUrl');
    print('SUPABASE_ANON_KEY: $supabaseAnonKey');
    print(''); // Empty line for readability
  }

  final navigationService = NavigationService();

  if (kIsWeb) {
    navigationService.initializeHistory();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Create providers once at app startup
  final dioClient = DioClient(baseUrl: apiBaseUrl);
  final authRepository = AuthRepository(dioClient);
  final authProvider = AuthProvider(authRepository);
  dioClient.setTokenRefreshCallback(authProvider.handleTokenRefresh);
  final onboardingRepository = OnboardingRepository(dioClient, authProvider);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => AppRoot(
        navigationService: navigationService,
        dioClient: dioClient,
        authProvider: authProvider,
        onboardingRepository: onboardingRepository,
      ),
    ),
  );
}

class AppRoot extends StatelessWidget {
  final NavigationService navigationService;
  final DioClient dioClient;
  final AuthProvider authProvider;
  final OnboardingRepository onboardingRepository;

  const AppRoot({
    required this.navigationService,
    required this.dioClient,
    required this.authProvider,
    required this.onboardingRepository,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<NavigationService>.value(
            value: navigationService),
        provider.ChangeNotifierProvider<AuthProvider>.value(
            value: authProvider),
        provider.ChangeNotifierProvider(
          create: (_) => OnboardingProvider(onboardingRepository),
        ),
        provider.Provider(create: (_) => ApiClient(baseUrl: apiBaseUrl)),
        provider.Provider(create: (_) => dioClient),
        provider.ChangeNotifierProvider(
          create: (context) => InvoiceProvider(
            InvoiceRepository(dioClient),
            authProvider,
          ),
        ),
        provider.Provider(
          create: (context) => ProductRepository(dioClient),
        ),
        provider.ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductRepository>(),
          ),
        ),
        provider.Provider(
          create: (context) => ClientRepository(dioClient),
        ),
        provider.ChangeNotifierProvider(
          create: (context) => ClientProvider(context.read<ClientRepository>()),
        ),
        provider.ChangeNotifierProvider(
          create: (context) => DashboardProvider(
            DashboardRepository(dioClient),
            authProvider,
          ),
        ),
      ],
      child: const SmartInvoiceApp(),
    );
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
      navigatorKey: navigatorKey,
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
  Future<void>? _initFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFuture ??= _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await ImagePrecacher.precacheImages(context);
      // Add any other initialization tasks here
    } catch (e) {
      debugPrint('Initialization error: $e');
      // Handle initialization errors gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initFuture == null) {
      return _buildLoadingScreen();
    }

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
