import 'package:flutter/material.dart';
import './qr_data.dart';

Widget qri = qrimg;

class GenerateQR extends StatefulWidget {
  const GenerateQR({Key? key}) : super(key: key);

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Generate QR Code'),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
              child: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Card(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 100),
                            elevation: 2.0,
                            color: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              width: 360.00,
                              height: 230.00,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextField(
                                      controller: emailController,
                                      style: const TextStyle(
                                          fontFamily: "SignikaSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.mail,
                                            color: Colors.black,
                                            size: 22.0,
                                          ),
                                          hintText: "Enter email",
                                          hintStyle: TextStyle(
                                              fontFamily: "SignikaSemiBold",
                                              fontSize: 18.0)),
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 40.0),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          String str = genertaeQr(emailController.text);
                                          print(str);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 42.0),
                                          child: Text(
                                            "Generate QR",
                                            style: TextStyle(
                                                fontFamily: "SignikaSemiBold",
                                                color: Colors.white,
                                                fontSize: 22.0),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }

  String genertaeQr(String text) {
    print(text);
    return '${text}i';
  }
}
