import 'package:flutter/material.dart';

class CountPage extends StatefulWidget {
  const CountPage({
    super.key,
    required this.c,
  });
  final int c;

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 50, 65, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Has attended ${widget.c} sessions',
                style: const TextStyle(
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
          ),
        ));
  }
}
