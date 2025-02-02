import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testapp/firebase_options.dart';
import 'package:testapp/views/delivery_view.dart';
import 'package:testapp/views/files_view.dart';
import 'package:testapp/views/forgot_password_view.dart';
import 'package:testapp/views/home_page_view.dart';
import 'package:testapp/views/login_view.dart';
import 'package:testapp/views/pod_capture_view.dart';
import 'package:testapp/views/account_view.dart';
import 'package:testapp/utils/qr_scan_view.dart';
import 'package:testapp/views/register_view.dart';
import 'package:testapp/views/settings_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  // Ensure that plugin services are initialized so that 'availableCameras()'
  // can be called before 'runApp()'
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure firebase is initialised before running app
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      title: 'Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xff1b6ec2),
        secondaryHeaderColor: const Color(0xffd3d3d3),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffd3d3d3), foregroundColor: Colors.black),
      ),
      home: const HomePageView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/homePage': (context) => const HomePageView(),
        '/qrScanner': (context) => const QrScanView(),
        '/podCapture': (context) => const PodCaptureView(),
        '/forgotPassword': (context) => const ForgotPasswordView(),
        '/files': (context) => const FilesView(),
        '/account': (context) => const AccountView(),
        '/settings': (context) => const SettingsView(),
        '/delivery': (context) => const DeliveryView(),
      },
    ),
  );
}
