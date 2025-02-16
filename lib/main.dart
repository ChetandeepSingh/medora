import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/pharmacy_list_screen.dart';
import 'screens/medicine_list_screen.dart';
import 'screens/reset_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MedoraApp());
}

class MedoraApp extends StatelessWidget {
  const MedoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medora App',
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/home": (context) => HomeScreen(),
        "/profile": (context) => ProfileScreen(),
        "/pharmacies": (context) => PharmacyListScreen(),
        "/reset-password": (context) => ResetPasswordScreen(),
      },
    );
  }
}