import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilesView extends StatefulWidget {
  final String? pdfFilePath;

  const FilesView({super.key, required this.pdfFilePath});

  @override
  State<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  String? _savedPdfFilePath;
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadSavedPdfPath(); // Load saved pdf when widit is initialised
  }

  Future<void> _loadSavedPdfPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPdfFilePath = prefs.getString('pdfFilePath');
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate to different pages based on selected index
    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
        break;
      case 1:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/files',
          (route) => false,
        );
        break;
      case 2:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/homePage',
          (route) => false,
        );
        break;
      case 3:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/profile',
          (route) => false,
        );
        break;
      case 4:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/settings',
          (route) => false,
        );
        break;
    }
  }

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
              child: const Text("Files"),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display saved pdf's
            if (_savedPdfFilePath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Saved PDF: $_savedPdfFilePath'),
                  onTap: () {
                    OpenFile.open(_savedPdfFilePath!);
                  },
                  tileColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            if (_savedPdfFilePath == null)
              const Center(child: Text('No PDF files saved')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "My Files"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
      ),
    );
  }
}
