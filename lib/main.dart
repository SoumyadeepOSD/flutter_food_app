import 'package:foodapp/auth/login.dart';
import 'package:foodapp/home.dart';
import 'package:foodapp/screens/cart.dart';
import 'package:foodapp/providers/generalState.dart';
import 'package:foodapp/screens/orders.dart';
import 'package:foodapp/screens/profile.dart';
import 'package:foodapp/screens/settings.dart';
import 'package:foodapp/screens/share.dart';
import 'package:foodapp/services/api/api_service.dart';
import 'package:foodapp/utils/user_simple_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? token;
bool isVerified = false;
Future<bool>? _checkTokenFuture;

ApiService apiService = ApiService();

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
    _checkTokenFuture = checkToken();
  }

  Future<bool> checkToken() async {
    bool verified = (await apiService.verifyToken())!;
    return verified;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GeneralStateProvider(),
        ),
      ],
      child: MaterialApp(
        routes: {
          "/home": (context) => const HomePage(),
          "/profile": (context) => const Profile(),
          "/cart": (context) => const CartPage(),
          "/orders": (context) => const Orders(),
          "/settings": (context) => const Settings(),
          "/share": (context) => const SharePage(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: _checkTokenFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData && snapshot.data == true) {
              return const HomePage();
            } else {
              return const Login();
            }
          },
        ),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
