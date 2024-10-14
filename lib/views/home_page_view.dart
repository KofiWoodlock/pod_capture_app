import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int selectedIndex = 2;

  // TODO: Dynamically fetch data from Snapwire to populate delivery tasks?
  // 

  final List<Map<String, String>> deliveries = [
    {"id": "4902-FCA", "info": "Extra info"},
    {"id": "4901-FCA", "info": "Extra info"},
    {"id": "4900-FCA", "info": "Extra info"},
    {"id": "4899-FCA", "info": "Extra info"},
    {"id": "4898-FCA", "info": "Extra info"},
    {"id": "4897-FCA", "info": "Extra info"},
    {"id": "4896-FCA", "info": "Extra info"},
    {"id": "4895-FCA", "info": "Extra info"},
    {"id": "4894-FCA", "info": "Extra info"},
  ];

  void removeDelivery(String deliveryId) {
    setState(() {
      deliveries.removeWhere((delivery) => delivery["id"] == deliveryId);
      devtools.log("Removed delivery: $deliveryId");
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
              child: const Text("Home"),
            )
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: deliveries.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  deliveries[index]["id"]!,
                  style: const TextStyle(fontSize: 24),
                ),
                subtitle: Text(deliveries[index]["info"]!),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/delivery',
                    arguments: {
                      'id': deliveries[index]["id"],
                      'removeDelivery': removeDelivery,
                    },
                  );
                },
              ),
            );
          }),
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
}
