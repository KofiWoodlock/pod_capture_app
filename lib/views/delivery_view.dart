import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  String? deliveryId;
  Function? removeDelivery;

  @override
  void initState() {
    super.initState();
    // Do not access inherited widgets here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch arguments from ModalRoute safely
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      deliveryId = args['id'];
      removeDelivery = args['removeDelivery'];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (deliveryId == null || removeDelivery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No delivery to remove"),
        ),
      );
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(child: Text('Delivery information not available')),
      );
    }

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
              child: Text(deliveryId!), // Display the delivery ID
            ),
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
                  }, // POD scan btn
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    iconSize: WidgetStateProperty.all(35),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                  ),
                  child: const Icon(Icons.document_scanner),
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
                      title: const Text("Cancel"),
                      content: const Text(
                          "Are you sure you want to cancel delivery?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No")),
                        TextButton(
                            onPressed: () {
                              // Invoke the removeDelivery callback
                              devtools.log("Preparing to remove delivery");
                              removeDelivery!(deliveryId);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/homePage",
                                (route) => false,
                              );
                            },
                            child: const Text("Yes")),
                      ],
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Theme.of(context).primaryColor),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: const Text(
                  "Cancel delivery",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
