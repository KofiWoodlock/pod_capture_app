import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => AccountViewState();
}

class AccountViewState extends State<AccountView> {
  int selectedIndex = 3;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userEmail = user?.email ?? "No email found";
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
    double deviceHeight = MediaQuery.sizeOf(context).height;
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
              child: const Text("Account"),
            )
          ],
        ),
      ),
      body: SizedBox(
        height: deviceHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 60,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.only(left: 6.0, bottom: 8.0),
              width: 300,
              child: Text(
                "Email: $_userEmail",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
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
}
