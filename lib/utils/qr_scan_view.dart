import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:developer' as devtools show log;

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  bool _isDialogShowing = false;

  void _showDialog(String qrData) {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('QR Detected'),
            content: Text(qrData),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/homePage', // Login view named route
              (route) => false,
            );
          },
        ),
      ),
      body: SizedBox(
        height: 400,
        child: MobileScanner(onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String qrData = barcode.rawValue ?? "No Data found in QR";
            devtools.log(qrData);
            _showDialog(qrData);
            break;
          }
        }),
      ),
    );
  }
}
