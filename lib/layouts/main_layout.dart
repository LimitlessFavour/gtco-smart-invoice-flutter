import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/layouts/web_main_layout.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/dashboard_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive_utils.dart';
import 'mobile_layout.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  
  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().loadInitialData();
    context.read<InvoiceProvider>().setup();
    context.read<ClientProvider>().loadClients();
    context.read<ProductProvider>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: ResponsiveUtils.isMobileScreen(context)
              ? const MobileLayout()
              : const DesktopLayout(),
        );
      },
    );
  }
}
