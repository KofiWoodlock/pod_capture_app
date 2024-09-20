import 'package:flutter/material.dart';

class DeliveryView extends StatelessWidget {
  const DeliveryView({super.key});

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
      body: Column(
        children: [
          Container(
            color: Colors.amber,
            height: 150,
          ),
          Container(
            color: Colors.grey,
            height: 290,
          ),
          Container(
            height: 100,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/pdfScanner', (route) => false);
                },
                child: Icon(Icons.document_scanner),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    iconSize: WidgetStateProperty.all(35),
                    shape: WidgetStateProperty.all(CircleBorder()),
                    padding: WidgetStateProperty.all(EdgeInsets.all(12))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
