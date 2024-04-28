import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './service/common_service.dart';
import './views/initial_page.dart';
import './views/login_page.dart';
import './views/signup_page.dart';
import './views/home_page.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CommonService(prefs)),
    ],
    child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
				debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const InitialPage(),
          '/login': (context) => const LogInPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
        },
    );
  }
}
