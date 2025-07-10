import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_attendance_app/attendance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class AttendanceSchema {
  final String cid;
  final String sid;
  final DateTime scantime;

  AttendanceSchema(this.cid, this.sid, this.scantime);

  Map toJson() => {
        'classid': cid,
        'studentid': sid,
        'scantime': scantime.toIso8601String(),
      };
}

class ScanPage extends StatefulWidget {
  final String sid;

  ScanPage(this.sid);

  @override
  _ScanPageState createState() => _ScanPageState(sid);
}

class _ScanPageState extends State<ScanPage> {
  String sid;

  _ScanPageState(this.sid);

  String qrCodeResult = "Scan The QR for Attendance";
  late DateTime start;
  late DateTime end;
  late Map _response;

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.5, 1],
              colors: [Color(0xff661EFF), Color(0xffFFA3FD)],
            ),
          ),
        ),
        title: const Text(
          "QR Scanner",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Scan the QR',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'for',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Attendance',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 3,
                thickness: 2,
                color: Color(0xff6C63FF),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15.0),
                  backgroundColor: const Color(0xff5F2EEA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                onPressed: () async {
                  // Scan QR code
                  ScanResult scanResult = await BarcodeScanner.scan();
                  String codeScanner = scanResult.rawContent;

                  if (codeScanner.isEmpty) return;

                  setState(() {
                    qrCodeResult = codeScanner;
                  });

                  var details = codeScanner.split(",");
                  if (details.length < 5) {
                    Fluttertoast.showToast(
                      msg: "Invalid QR code format",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  start = DateTime.parse(details[0]);
                  end = DateTime.parse(details[1]);

                  AttendanceSchema s1 =
                      AttendanceSchema(details[4], sid, DateTime.now());
                  Map data = s1.toJson();
                  String body1 = json.encode(data, toEncodable: myEncode);

                  var client = http.Client();
                  try {
                    var uriResponse = await client.post(
                      Uri.parse('https://your-api-url.com/mark-attendance'),
                      headers: {
                        "Content-Type": "application/json;charset=UTF-8"
                      },
                      body: body1,
                    );
                    _response = json.decode(uriResponse.body);
                  } finally {
                    if (_response["present"] == true) {
                      Fluttertoast.showToast(
                        msg: "Attendance added for class ${details[2]}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        fontSize: 20.0,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg:
                            "You have scanned late. Please contact the faculty.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        fontSize: 20.0,
                      );
                    }
                  }
                },
                child: const Text(
                  "Open Scanner",
                  style: TextStyle(
                    color: Color(0xffF7F7FC),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildButton("Check Attendance", AttendancePage(_response)),
              const SizedBox(height: 35),
              SvgPicture.asset(
                "assets/phone.svg",
                height: 282,
                width: 342,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, Widget widget) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15.0),
        backgroundColor: const Color(0xff5F2EEA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
      onPressed: () async {
        var client = http.Client();
        try {
          var uriResponse = await client.get(
            Uri.parse(
                'https://your-api-url.com/get-attendance/$sid'), // update this
            headers: {"Content-Type": "application/json;charset=UTF-8"},
          );
          Map _response = json.decode(uriResponse.body);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AttendancePage(_response),
            ),
          );
        } finally {
          client.close();
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xffF7F7FC),
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
