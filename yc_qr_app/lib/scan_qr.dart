// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/cupertino.dart';
import 'package:yc_qr_app/entry_denied.dart';
import 'package:yc_qr_app/entry_ok.dart';
import './count_page.dart';
import 'package:yc_qr_app/exit.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

String emailName = "";
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = database.ref('People');

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
        body: Center(
          child: SafeArea(
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
                          emailName = valueMap['email'];
                          bool res;
                          if (valueMap['email'] != "error") {
                            res = await mark_entry(valueMap);
                            if (res) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EntryDenied(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GiveEntry(email: valueMap['email']),
                                ),
                              );
                            }
                          } else {
                            invalid(context);
                          }
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
                          String res = "";
                          if (valueMap['email'] != "error") {
                            res = await mark_exit(valueMap);
                            if (res == 'Invalid QR') {
                              invalid(context);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ExitPage(),
                                ),
                              );
                            }
                          } else {
                            invalid(context);
                          }
                        },
                        icon: const Icon(Icons.exit_to_app_sharp),
                        label: const Text('Exit Scan'),
                      ),
                    ),
                  ),
                ]),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Map valueMap = await _scan(context);
                      emailName = valueMap['email'];
                      int res;
                      if (valueMap['email'] != "error") {
                        res = await session_entry(valueMap);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                GiveEntry(email: valueMap['email']),
                          ),
                        );
                      } else {
                        invalid(context);
                      }
                    },
                    icon: const Icon(CupertinoIcons.arrow_right),
                    label: const Text('Session Entry'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Map valueMap = await _scan(context);
                      emailName = valueMap['email'];
                      int res;
                      if (valueMap['email'] != "error") {
                        res = await count(valueMap);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CountPage(c: res),
                          ),
                        );
                      } else {
                        invalid(context);
                      }
                    },
                    icon: const Icon(CupertinoIcons.arrow_right),
                    label: const Text('Count'),
                  ),
                ),
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
      ),
    );
  }
}

String getKey(email) {
  String s = '';
  email.runes.forEach((c) {
    var l = String.fromCharCode(c);
    if (l != '.' && l != '@') {
      s += l;
    }
  });
  return s;
}

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
  bool curr_val = true;
  final snapshot1 =
      await ref.child(getKey(data['email'])).child('present').get();
  final snapshot2 =
      await ref.child(getKey(data['email'])).child('sessions_attended').get();
  if (snapshot1.exists && snapshot2.exists) {
    curr_val = snapshot1.value as bool;
  }
  if (!curr_val) {
    ref.child(getKey(data['email'])).update({'present': true});
  }
  return curr_val;
}

Future session_entry(data) async {
  int curr_val = 0;
  final snapshot =
      await ref.child(getKey(data['email'])).child('sessions_attended').get();
  if (snapshot.exists) {
    // print('snapshot- $snapshot.value');
    curr_val = snapshot.value as int;
    ref
        .child(getKey(data['email']))
        .update({'sessions_attended': curr_val + 1});
  } else {
    ref.child(getKey(data['email'])).update({'sessions_attended': 1});
  }
  return curr_val;
}

Future mark_exit(data) async {
  var msg = '';
  final snapshot =
      await ref.child(getKey(data['email'])).child('present').get();
  if (snapshot.exists) {
    ref.child(getKey(data['email'])).update({'present': false});
  } else {
    msg = 'Invalid QR';
  }
  return msg;
}

Future count(data) async {
  int c = 0;
  final snapshot =
      await ref.child(getKey(data['email'])).child('sessions_attended').get();
  if (snapshot.exists) {
    c = snapshot.value as int;
  }
  return c;
}

invalid(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            title: const Text("Error",
                style: TextStyle(
                  color: Colors.red,
                )),
            content: const Text("Invalid QR code"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      });
}
