import 'package:flutter/material.dart';

class ExitPage extends StatefulWidget {
  const ExitPage({
    super.key,
  });
  @override
  State<ExitPage> createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage('./assets/exit.webp'),
                fit: BoxFit.fitWidth, width: 500,), 
            const SizedBox(height: 20),
            const Text(
              'Exit Marked',
              style: TextStyle(
                  fontFamily: 'SignikaSemiBold',
                  fontSize: 20,
                  color: Color.fromARGB(255, 11, 58, 179)),
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
