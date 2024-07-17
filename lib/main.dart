import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import './service/auth_service.dart';
import './service/products_service.dart';
// import './views/initial_page.dart';
import './views/login_page.dart';
import './views/signup_page.dart';
import './views/home_page.dart';
import './views/product_info_page.dart';
import './views/products_list_page.dart';
import './service/navigation_key.dart';
import './keys.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	SharedPreferences prefs = await SharedPreferences.getInstance();
  KakaoSdk.init(
    nativeAppKey: Secret.shared.kakaoApiKey,
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthService(prefs)),
      ChangeNotifierProvider(create: (context) => ProductsService()),
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
    AuthService service = context.read<AuthService>();
    return MaterialApp(
				debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.shared.navigationState,
        initialRoute: service.userToken == null ? '/login' : '/home',
        routes: {
          // '/': (context) => const InitialPage(),
          '/login': (context) => const LogInPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/product': (context) => const ProductInfoPage(),
          '/productsList' : (context) => const ProductsListPage(),
        },
    );
  }
}
