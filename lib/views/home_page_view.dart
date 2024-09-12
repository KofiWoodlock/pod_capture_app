import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:testapp/views/camera_view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/logo_fca1.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Home"),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const Text('Welcome to the Home Page!'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/qrScanner',
                (route) => false,
              );
            },
            child: const Text('QR Scan'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/pdfScanner',
                (route) => false,
              );
            },
            child: const Text('PDF Scan'),
          ),
          ElevatedButton(
            // Retrive available cameras
            onPressed: () async {
              final cameras = await availableCameras();
              final firstCamera = cameras.first;

              // Navigate to the TakePictureScreen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TakePictureScreen(camera: firstCamera),
                ),
              );
            },
            child: const Text('Open Camera'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
