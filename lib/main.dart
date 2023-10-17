import 'package:flutter/material.dart';
import 'package:foodapp/Frontend/auth/signup.dart';
import 'package:foodapp/Frontend/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodapp/Frontend/state/generalState.dart';
import 'package:provider/provider.dart';

void main() {
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
        )
      ],
      child: MaterialApp(
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
              bool hasSignedUp = snapshot.hasData;
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
