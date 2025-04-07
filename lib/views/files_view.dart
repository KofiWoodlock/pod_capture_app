import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class FilesView extends StatefulWidget {
  const FilesView({super.key});

  @override
  State<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  List<String> _savedPdfFilePaths = [];
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadSavedPdfPath(); // Load saved pdf when wigit is initialised
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
          '/account',
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
      body: _savedPdfFilePaths.isNotEmpty
          ? ListView.builder(
              itemCount: _savedPdfFilePaths.length,
              itemBuilder: (context, index) {
                final filePath = _savedPdfFilePaths[index].split("cache/").last;
                return Dismissible(
                  key: Key(filePath),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    try {
                      setState(() {
                        _savedPdfFilePaths.removeAt(index);
                      });
                    } on Exception catch (e) {
                      devtools.log(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Error when deleting PDF!")));
                    }
                    // Update the shared prefences to reflect the list
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setStringList(
                        'pdfFilePaths', _savedPdfFilePaths);
                    devtools.log('$filePath Deleted');

                    // Display message to show PDF has been deleted
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("PDF deleted"),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Saved PDF: $filePath'),
                      onTap: () {
                        OpenFile.open(filePath);
                      },
                      tileColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No PDF files saved'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "My Files"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
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

  Future<void> _loadSavedPdfPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Fetch the list of saved PDF paths
      _savedPdfFilePaths = prefs.getStringList('pdfFilePaths') ?? [];
    });
  }
}
