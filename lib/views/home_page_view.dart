import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int selectedIndex = 2;

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
              child: const Text("Home"),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "Current Deliveries",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Delivery 1",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text("Extra info"),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/delivery',
                  (route) => false,
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Delivery 2",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text("Extra info"),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/delivery',
                  (route) => false,
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Delivery 3",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text("Extra info"),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/delivery',
                  (route) => false,
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Delivery 4",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text("Extra info"),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/delivery',
                  (route) => false,
                );
              },
            ),
          )
        ],
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
