import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/auth/login.dart';
import 'package:foodapp/auth/signup.dart';
import 'package:foodapp/home.dart';
import 'package:foodapp/pages/cart.dart';
import 'package:foodapp/state/generalState.dart';
import 'package:foodapp/utils/user_simple_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UserSimplePreferences.init();
  runApp(const MyApp());
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
    loadToken();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => generalStateProvider(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => const HomePage(),
          '/cart': (context) => const Cart(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          useMaterial3: true,
        ),
        home: token == null ? const Signup() : const Login(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
