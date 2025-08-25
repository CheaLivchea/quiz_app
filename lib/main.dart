import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/welcome/screens/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/features/auth/providers/auth_provider.dart';
import 'package:quiz_app/features/auth/screens/login.dart';
import 'package:quiz_app/features/auth/services/auth_service.dart';
import 'package:quiz_app/features/auth/utils/token_manager.dart';
import 'package:quiz_app/features/home_page/screens/QuizDashboard.dart';
import 'package:quiz_app/shared/services/http_overrides.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/profile/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();

  final authService = AuthService();
  final tokenManager = TokenManager();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, tokenManager),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
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
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    Future.delayed(Duration.zero, () {
      context.read<AuthProvider>().checkAuthState();
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunched = prefs.getBool('hasLaunched') ?? false;
    setState(() {
      _isFirstLaunch = !hasLaunched;
    });
    if (!hasLaunched) {
      await prefs.setBool('hasLaunched', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF6A3FC6),
        brightness: Brightness.light,
      ),
      home: _isFirstLaunch
          ? const WelcomePage()
          : Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.isAuthenticated) {
                  return Quizdashboard();
                }
                return Login();
              },
            ),
    );
  }
}
