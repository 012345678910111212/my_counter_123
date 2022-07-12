import 'package:churchapplication/providers/user_provider.dart';
import 'package:churchapplication/resources/auth_methods.dart';
import 'package:churchapplication/screens/home_screen.dart';
import 'package:churchapplication/screens/login_screens.dart';
import 'package:churchapplication/screens/onboarding_screen.dart';
import 'package:churchapplication/screens/signup_screen.dart';
import 'package:churchapplication/utils/colors.dart';
import 'package:churchapplication/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapplication/models/user.dart' as models;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA-DjEDxQw2OAwhYMdjcqhNyd64vBomTwo",
        authDomain: "streaming-c1e8f.firebaseapp.com",
        projectId: "streaming-c1e8f",
        storageBucket: "streaming-c1e8f.appspot.com",
        messagingSenderId: "420926725940",
        appId: "1:420926725940:web:e8323db127ccd599c18f61",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lovereign bible church',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: backgroundColor,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(
            color: primaryColor,
          ),
        ),
      ),
      routes: {
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
      home: FutureBuilder(
        future: AuthMethods()
            .getCurrentUser(FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : null)
            .then((value) {
          if (value != null) {
            Provider.of<UserProvider>(context, listen: false).setUser(
              models.User.fromMap(value),
            );
          }
          return value;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Put splash screen here
            return const LoadingIndicator();
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const OnboardingScreen();
        },
      ),
    );
  }
}
