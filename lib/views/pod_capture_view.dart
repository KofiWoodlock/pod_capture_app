// Import necessary Flutter and Dart libraries
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/views/files_view.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_storage/firebase_storage.dart';

// Define the PodCaptureView widget as a stateful widget
class PodCaptureView extends StatefulWidget {
  const PodCaptureView({super.key});

  @override
  State<PodCaptureView> createState() => _PodCaptureViewState();
}

// Define the state for PodCaptureView
class _PodCaptureViewState extends State<PodCaptureView> {
  // Create an empty array to store the file paths of scanned images
  List<String> _pictures = [];
  get date => _getCurrentDate();

  // Declare file variable as a class level variable
  //so it can be used in other methods
  File? file;

  // upload progress indicator variable
  double uploadProgress = 0.0;

  // Initialise firebase cloud firestore for storage of pdf files
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

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
                          '/homePage',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: addScan,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
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
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text('Open'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _savePdf();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (file != null) {
                      uplaodPdf();
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
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text('Upload'),
                ),
              ],
            ),
            if (uploadProgress > 0.0 && uploadProgress < 100.0)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: uploadProgress / 100, // Display progress
                  semanticsLabel: "Linear progress indicator",
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
    final formatter = DateFormat('dd-MM-yyyy kk:mm');
    return formatter.format(now);
  }

  // Method that gets triggered when the 'Add Scan' button is pressed
  void addScan() async {
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
      devtools.log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error! $e'),
        ),
      );
    }
  }

  Future<void> _createPdf() async {
    final pdf = pw.Document();
    // Randomply generate a 4 digit id so each file path is unique
    Random random = Random();
    int pdfId = random.nextInt(10000);

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
      file = File("${output.path}/$date-$pdfId.pdf");
      devtools.log(file.toString());
      await file!.writeAsBytes(await pdf.save());
      devtools.log("PDF created");
      // Display message to show user file has been created
    } on Exception catch (e) {
      devtools.log(e.toString());
    }
  }

  void _savePdf() async {
    if (file != null) {
      try {
        // Fetch current list of saved PDF's from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> pdfList = prefs.getStringList('pdfFilePaths') ?? [];

        // Add new PDF file path to the list
        pdfList.add(file!.path);

        //Save updated list to SharedPreferences
        await prefs.setStringList('pdfFilePaths', pdfList);

        // Navigate to FilesView with the file path
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FilesView(),
          ),
        );
      } catch (e) {
        devtools.log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error saving PDF!"),
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

  void uplaodPdf() async {
    if (file != null) {
      try {
        final String fileName =
            '${_getCurrentDate()}_${file!.path.split('/').last}';
        final pdfRef = storageRef.child('pdfs/$fileName');

        final uploadTask = pdfRef.putFile(file!);

        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {
                uploadProgress = progress;
              });
              break;
            case TaskState.paused:
              devtools.log("Upload Paused");
              break;
            case TaskState.canceled:
              devtools.log("Upload Cancelled");
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Upload Cancelled")));
              break;
            case TaskState.error:
              devtools.log("Error Uploading");
              break;
            case TaskState.success:
              devtools.log("Upload complete");
              setState(() {
                uploadProgress = 0.0;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          // route to home page
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/homePage", (route) => false);
                        },
                        child: const Text("Ok"),
                      ),
                    ],
                    title: const Text("Upload complete"),
                    content: const Text(
                        "The pdf file has been successfully uploaded "),
                  );
                },
              );
              break;
          }
        });
      } catch (e) {
        devtools.log("Upload failed: $e");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Upload Failed")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No file to upload")));
    }
  }
}
