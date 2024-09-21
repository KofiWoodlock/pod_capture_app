import 'package:flutter/material.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
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
              child: const Text("Delivery"),
            )
          ],
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/homePage',
            (route) => false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recipient Name",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  "Delivery address",
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  "Delivery Instructions",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 320,
              child: Image(
                image: AssetImage('assets/map_placeholder.png'),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 100,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/podCapture',
                      (route) => false,
                    );
                  },
                  child: Icon(Icons.document_scanner), // POD scan btn
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      iconSize: WidgetStateProperty.all(35),
                      shape: WidgetStateProperty.all(CircleBorder()),
                      padding: WidgetStateProperty.all(EdgeInsets.all(12))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("Cancel"),
                      content:
                          Text("Are you sure you want to cancel delivery?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("No")),
                        TextButton(
                            onPressed: () {
                              // Handle removing the delivery from homepage
                            },
                            child: Text("Yes")),
                      ],
                    ),
                  );
                },
                child: Text(
                  "Cancel delivery",
                  style: TextStyle(fontSize: 16),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Theme.of(context).primaryColor),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
