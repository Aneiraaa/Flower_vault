import 'package:firebase_core/firebase_core.dart';
import 'package:flower_vault/firebase_options.dart';
import 'package:flower_vault/pages/add_flower_page.dart';
import 'package:flower_vault/pages/dashboard/dashboard_page.dart';
import 'package:flower_vault/pages/detail_page.dart';
import 'package:flower_vault/pages/login_page.dart';
import 'package:flower_vault/pages/register_page.dart';
import 'package:flower_vault/pages/update_flower_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Pencatatan',
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => const DashboardPage(),
      '/addFlower': (context) => const AddFlowerPage(),
      '/detail': (context) => const DetailPage(),
      '/update': (context) => const UpdateFlowerPage(),
    },
  ));
}
