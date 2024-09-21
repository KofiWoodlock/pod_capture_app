// Import necessary Flutter and Dart libraries
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Scan Document')), // AppBar title
            leading: BackButton(
              // Back button to navigate back to the home page
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Warning"),
                    content: const Text("Going back will delete unsaved scans"),
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
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
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
                                    content: Text(
                                        "No file to open"))); // TODO: fix error when trying to open pdf files with no scanned images
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        child: const Text('Open'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle saving pdf to my files page and local device
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle uploading to snapwire server
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
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
        ),
      ),
    );
  }

  // Method that gets triggered when the 'Add Scan' button is pressed
  void onPressed() async {
    List<String> pictures;
    try {
      // Use the CunningDocumentScanner package to start scanning documents
      // and get a list of file paths for the scanned images
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
      // Print any errors that occur during the scanning process
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
      file = File("${output.path}/example.pdf");
      await file!.writeAsBytes(await pdf.save());
      print("PDF created");
      // Display message to show user file has been created
    } on Exception catch (e) {
      print(e);
    }
  }
}
