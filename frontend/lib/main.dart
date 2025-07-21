import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motouber/screens/home_screen.dart';
import 'package:motouber/screens/login_screen.dart';
import 'package:motouber/screens/register_screen.dart';
import 'package:motouber/screens/sync_screen.dart';
import 'package:motouber/screens/premium_screen.dart';
import 'package:motouber/services/database_service.dart';
import 'package:motouber/services/theme_service.dart';
import 'package:motouber/services/sync_service.dart';
import 'package:motouber/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(const KMDollarApp());
}

class KMDollarApp extends StatelessWidget {
  const KMDollarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()..init()),
        ChangeNotifierProvider(create: (_) => SyncService.instance),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'KM$ - Controle Financeiro para Motoristas',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/sync': (context) => const SyncScreen(),
              '/premium': (context) => const PremiumScreen(),
            },
          );
        },
      ),
    );
  }
}