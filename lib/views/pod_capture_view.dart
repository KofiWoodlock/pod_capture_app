// Import necessary Flutter and Dart libraries
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/views/files_view.dart';

// Define the PodCaptureView widget as a stateful widget
class PodCaptureView extends StatefulWidget {
  const PodCaptureView({super.key});

  @override
  State<PodCaptureView> createState() => _PodCaptureViewState();
}

// Define the state for PodCaptureView
class _PodCaptureViewState extends State<PodCaptureView> {
  // Create an empty list to store the file paths of scanned images
  List<String> _pictures = [];

  // Declare file variable as a class level variable
  //so it can be used in other methods
  File? file;

  get date => _getCurrentDate();
  late int counter = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // This method is used to initialize platform-specific states (e.g., permissions)
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    // The main UI for the PDF scanner, built using a MaterialApp
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Scan Document')),
        leading: BackButton(
          // Back button to navigate back to the home page
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Warning"),
                content: const Text("Any unsaved scans will be deleted"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/delivery',
                          (route) => false,
                        );
                      },
                      child: const Text("Ok")),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        // Allows the content to be scrollable if it overflows
        child: Column(
          children: [
            // Button to initiate the document scanning process
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ), // Calls the onPressed method when tapped
                    child: const Text('New scan'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (file != null) {
                        OpenFile.open(file!.path);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No file to open"),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text('Open'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _savePdf();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (file != null) {
                        //TODO: Handle uploading to snapwire server
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No file to upload"),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text('Upload'),
                  ),
                ],
              ),
            ),
            // Display each scanned picture as an image
            for (var picture in _pictures)
              Image.file(
                File(picture),
              ), // Create an Image widget for each scanned file
          ],
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  // Method that gets triggered when the 'Add Scan' button is pressed
  void onPressed() async {
    counter++;
    print('incremented counter: $counter');
    List<String> pictures;
    try {
      // Get list of pictures using cunningdocumentscanner library
      pictures = await CunningDocumentScanner.getPictures(
            isGalleryImportAllowed: true,
          ) ??
          [];

      // Ensure that the widget is still mounted (part of the widget tree)
      if (!mounted) return;

      // Update the state with the new list of scanned images
      setState(() {
        _pictures = pictures;
      });

      // After user has scanned documents create a pdf with the list of images
      _createPdf();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error! $e'),
        ),
      );
    }
  }

  Future<void> _createPdf() async {
    final pdf = pw.Document();

    // Iteratre through the list of images and add them to pdf file
    try {
      for (var picture in _pictures) {
        final image = pw.MemoryImage(
          File(picture).readAsBytesSync(),
        );
        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        }));
      }
      final output = await getTemporaryDirectory();
      file = File("${output.path}/$date-$counter.pdf");
      await file!.writeAsBytes(await pdf.save());
      print("PDF created");
      // Display message to show user file has been created
    } on Exception catch (e) {
      print(e);
    }
  }

  void _savePdf() async {
    if (file != null) {
      try {
        // If save button pressed navigate to sharaed preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('pdfFilePath', file!.path); // Save file path

        // Navigate to FilesView with the file path
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FilesView(pdfFilePath: file!.path)),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error saving pdf!"),
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No file to save"),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }
}
