import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testapp/firebase_options.dart';
import 'package:testapp/views/camera_view.dart';
import 'package:testapp/views/delivery_view.dart';
import 'package:testapp/views/files_view.dart';
import 'package:testapp/views/home_page_view.dart';
import 'package:testapp/views/login_view.dart';
import 'package:testapp/views/pdf_scanner_view.dart';
import 'package:testapp/views/profile_view.dart';
import 'package:testapp/views/qr_scan_view.dart';
import 'package:testapp/views/register_views.dart';
import 'package:camera/camera.dart';
import 'package:testapp/views/settings_view.dart';
import 'package:testapp/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure firebase is initialised before running app
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that plugin services are initialized so that 'availableCameras()'
  // can be called before 'runApp()'

  // Initialise cameras
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

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
      home: HomePageView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/homePage': (context) => HomePageView(),
        '/qrScanner': (context) => const QrScanView(),
        '/pdfScanner': (context) => const PdfScannerView(),
        '/camera': (context) => TakePictureScreen(camera: firstCamera),
        '/verifyEmail': (context) => const VerifyEmailView(),
        '/files': (context) => const FilesView(),
        '/profile': (context) => const ProfileView(),
        '/settings': (context) => const SettingsView(),
        '/delivery': (context) => const DeliveryView(),
      },
    ),
  );
}
