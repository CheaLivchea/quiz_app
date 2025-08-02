import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/features/auth/providers/auth_provider.dart';
import 'package:quiz_app/features/auth/screens/login.dart';
import 'package:quiz_app/features/auth/services/auth_service.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';
import 'package:quiz_app/features/home_page/screens/home_page.dart';
import 'package:quiz_app/shared/services/http_overrides.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();

  final authService = AuthService();
  final tokenManager = TokenManager();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(authService, tokenManager),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check auth state when app starts
    Future.delayed(Duration.zero, () {
      context.read<AuthProvider>().checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF6A3FC6),
        brightness: Brightness.light,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return HomePage();
          }
          return Login();
        },
      ),
    );
  }
}
