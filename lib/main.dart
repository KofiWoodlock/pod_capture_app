import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testapp/firebase_options.dart';
import 'package:testapp/views/camera_view.dart';
import 'package:testapp/views/home_page_view.dart';
import 'package:testapp/views/login_view.dart';
import 'package:testapp/views/pdf_scanner_view.dart';
import 'package:testapp/views/qr_scan_view.dart';
import 'package:testapp/views/register_views.dart';
import 'package:camera/camera.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/homePage': (context) => const HomePageView(),
        '/qrScanner': (context) => const QrScanView(),
        '/pdfScanner': (context) => const PdfScannerView(),
        '/camera': (context) => TakePictureScreen(camera: firstCamera),
        '/verifyEmail': (context) => const VerifyEmailView(),
      },
    ),
  );
}
