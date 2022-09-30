import 'package:flutter/material.dart';

class GiveEntry extends StatefulWidget {
  const GiveEntry({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<GiveEntry> createState() => _GiveEntryState();
}

class _GiveEntryState extends State<GiveEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 50, 65, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage('assets/done.gif'), fit: BoxFit.cover), // tick mark sprite
            const SizedBox(height: 20),
            const Text(
              'Entry Marked',
              style: TextStyle(
                  fontFamily: 'SignikaSemiBold',
                  fontSize: 20,
                  color: Colors.green),
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
