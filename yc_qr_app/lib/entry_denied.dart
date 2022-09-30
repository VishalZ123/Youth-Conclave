import 'package:flutter/material.dart';

class EntryDenied extends StatefulWidget {
  const EntryDenied({
    super.key,
  });

  @override
  State<EntryDenied> createState() => _EntryDeniedState();
}

class _EntryDeniedState extends State<EntryDenied> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                  './assets/denied.jpg'),
              fit: BoxFit.fitWidth,
              width: 500,
            ),
            const SizedBox(height: 20),
            const Text(
              'Entry Denied, the QR is scanned once or Not attended enough sessions',
              style: TextStyle(
                  fontFamily: 'SignikaSemiBold',
                  fontSize: 20,
                  color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ));
  }
}
