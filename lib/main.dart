import 'package:foodapp/Frontend/utils/user_simple_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/Frontend/state/generalState.dart';
import 'package:foodapp/Frontend/auth/signup.dart';
import 'package:foodapp/Frontend/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Frontend/pages/cart.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

String? authToken;
const storage = FlutterSecureStorage();

Future<bool> checkSignUpStatus() async {
  final value = await storage.read(key: 'mobile');
  return value != null;
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
    storage.read(key: 'mobile').then((value) {
      setState(() {
        authToken = value.toString();
      });
      // print(authToken);
    }).catchError((error) {
      print('Error removing key: $error');
    });
  }

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
        home: FutureBuilder<bool>(
          future: checkSignUpStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // bool hasSignedUp = snapshot.hasData;
              print(authToken);
              return authToken == 'null' ? const Signup() : const HomePage();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
