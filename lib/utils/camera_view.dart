// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'dart:developer' as devtools show log;

// class TakePictureScreen extends StatefulWidget {
//   const TakePictureScreen({super.key, required this.camera});

//   final CameraDescription camera;

//   @override
//   State<TakePictureScreen> createState() => _TakePictureScreenState();
// }

// class _TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initialiseControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     // To display current output from camera we must create a CameraController
//     _controller = CameraController(
//       widget.camera, // Get a specific camera from the list
//       ResolutionPreset.medium, // Define resolution to use
//     );
//     _initialiseControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Take a picture'),
//       ),
//       // You must wait until the controller is initialiazed before displaying
//       // the camera preview. Use a FutureBuilder to display a laoding spinner
//       // until the controller has finished initializing
//       body: FutureBuilder(
//         future: _initialiseControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If future builder is complete, display preview
//             return CameraPreview(_controller);
//           } else {
//             // Otherwise, display a loading indicator.
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _initialiseControllerFuture;
//             final image = await _controller.takePicture();
//             if (!context.mounted) return;
//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(
//                   imagePath: image.path,
//                 ),
//               ),
//             );
//           } catch (e) {
//             devtools.log(e.toString());
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }

// // Widget to display photo,
// //TODO: convert into stfl widget that allows multiple pictures to be taken
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   Future<void> _saveImage(BuildContext context) async {
//     try {
//       await GallerySaver.saveImage(imagePath);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Saved to gallery!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving image: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Display the Picture'),
//       ),
//       // The image is stored as a file on the device
//       // Use 'Image.file' constructor with the given path to display the image.
//       body: Column(
//         children: [
//           Expanded(child: Image.file(File(imagePath))),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton.icon(
//               onPressed: () => _saveImage(context),
//               icon: const Icon(Icons.save),
//               label: const Text('Save Image'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
