// Import necessary Flutter and Dart libraries
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

// Define the PdfScannerView widget as a stateful widget
class PdfScannerView extends StatefulWidget {
  const PdfScannerView({super.key});

  @override
  State<PdfScannerView> createState() => _PdfScannerViewState();
}

// Define the state for PdfScannerView
class _PdfScannerViewState extends State<PdfScannerView> {
  // Create an empty list to store the file paths of scanned images
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    // Initialize any platform-specific features or permissions
    initPlatformState();
  }

  // This method is used to initialize platform-specific states (e.g., permissions)
  Future<void> initPlatformState() async {
    // Currently, this method does nothing, but it's here to handle future needs
  }

  @override
  Widget build(BuildContext context) {
    // The main UI for the PDF scanner, built using a MaterialApp
    return MaterialApp(
      home: ScaffoldMessenger(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('PDF Scanner'), // AppBar title
            leading: BackButton(
              // Back button to navigate back to the home page
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/delivery', // Named route for the home page
                  (route) => false, // Remove all previous routes
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            // Allows the content to be scrollable if it overflows
            child: Column(
              children: [
                // Button to initiate the document scanning process
                ElevatedButton(
                  onPressed:
                      onPressed, // Calls the onPressed method when tapped
                  child: const Text('Add Scan'),
                ),
                // Display each scanned picture as an image
                for (var picture in _pictures)
                  Image.file(
                    File(picture),
                  ), // Create an Image widget for each scanned file
                ElevatedButton(
                  onPressed: createPdfFromPictures,
                  child: const Text("Create PDF"),
                )
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

      // Ensure that the widget is still mounted (i.e., part of the widget tree)
      if (!mounted) return;

      // Update the state with the new list of scanned images
      setState(() {
        _pictures = pictures;
      });
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

  // Method to create PDF from the list of pictures
  Future<void> createPdfFromPictures() async {
    final pdf = pw.Document();

    // loop through images and add to pdf document
    for (var picture in _pictures) {
      final image =
          pw.MemoryImage(File(picture).readAsBytesSync() // Read image file
              );
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image), // Display the image in the pdf
            );
          },
        ),
      );
    }
    try {
      // Get the directory to save the PDF
      final outputDir = await getApplicationDocumentsDirectory();
      final outputFile = File("${outputDir.path}/scanned__document.pdf");

      // Save the PDF file
      await outputFile.writeAsBytes(await pdf.save());

      // Show message if save was succsesful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PDF saved: ${outputFile.path}"),
        ),
      );
    } catch (e) {
      // Handle errors
      print("Error saving PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error saving PDF"),
        ),
      );
    }
  }
}
