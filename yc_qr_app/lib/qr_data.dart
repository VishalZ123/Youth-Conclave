import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

final qrKey = GlobalKey();
String qrData = 'yadav.388@iitj.ac.in';
//RepaintBoundary is necessary for saving QR to user's phone

Widget qrimg = RepaintBoundary(
  child: QrImage(
    data: qrData, //This is the part we give data to our QR
    size: 250,
    backgroundColor: Colors.white,
    version: QrVersions.auto,
  ),
);
