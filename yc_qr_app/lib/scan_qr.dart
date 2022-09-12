// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Image(
                image: AssetImage('assets/yc_logo.png'), // image
                height: 300,
                width: 200,
              ),
              const Text(
                'Youth Conclave',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 2,
                ),
              ),
              Row(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Map valueMap = await _scan(context);
                        String res="";
                        if (valueMap['email'] != "error") {
                          res = await mark_entry(valueMap);
                        }
                        print(res);
                      },
                      icon: const Icon(CupertinoIcons.arrow_right),
                      label: const Text('Entry Scan'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Map valueMap = await _scan(context);
                        // mark_exit(uuid);
                        String res="";
                        if (valueMap['email'] != "error") {
                          res = await mark_exit(valueMap);
                        }
                        print(res);
                      },
                      icon: const Icon(Icons.exit_to_app_sharp),
                      label: const Text('Exit Scan'),
                    ),
                  ),
                ),
              ]),
              const Text(
                'Made with ❤️ by Vishal',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ), // footer
            ],
          ),
        ),
      ),
    );
  }
}

String entryAPI = 'http://172.31.54.122:8000/entry';
String exitAPI = 'http://172.31.54.122:8000/exit';

Future _scan(context) async {
  await Permission.camera.request();
  String? data = await scanner.scan();
  if (data == null) {
    return {"email": "error", "uuid": "error"};
  }
  Map valueMap = json.decode(data);
  return valueMap;
}

var response;
Future mark_entry(data) async {
  response = await http.get(Uri.parse(entryAPI), headers: {
    // send a http request with email and uuid in headers
    "email": data['email'],
    "uuid": data["uuid"]
  });
  return response.body.toString();
}

Future mark_exit(data) async {
  response = await http.get(Uri.parse(exitAPI), headers: {
    "email": data['email'],
    "uuid": data["uuid"]
  });
  return response.body.toString();
}