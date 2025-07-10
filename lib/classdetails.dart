import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_app/generate.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ClassDetailSchema {
  final String classname;
  final DateTime start;
  final DateTime end;
  final String facultyid;

  ClassDetailSchema(this.classname, this.start, this.end, this.facultyid);

  Map<String, dynamic> toJson() => {
        'classname': classname,
        'starttime': start,
        'endtime': end,
        'facultyid': facultyid,
      };
}

class ClassDetailsPage extends StatefulWidget {
  final String id;
  ClassDetailsPage(this.id);

  @override
  _ClassDetailsPageState createState() => _ClassDetailsPageState(id);
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  final String id;
  _ClassDetailsPageState(this.id);

  final classnameController = TextEditingController();
  DateTime pickeddate = DateTime.now();
  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();

  late DateTime start1;
  late DateTime end1;
  late String cid;

  dynamic myEncode(dynamic item) {
    return (item is DateTime) ? item.toIso8601String() : item;
  }

  String formatTimeOfDay(TimeOfDay tod, DateTime date) {
    final dt = DateTime(date.year, date.month, date.day, tod.hour, tod.minute);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final startMin = start.minute.toString().padLeft(2, '0');
    final endMin = end.minute.toString().padLeft(2, '0');

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
          "Class Builder",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            SvgPicture.asset("assets/classbuilder.svg", height: 200, width: 181),
            const SizedBox(height: 20),

            // Class name
            TextField(
              controller: classnameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.edit),
                labelText: 'Class Name',
                filled: true,
                fillColor: Color(0xffEFF0F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffEFF0F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(pickeddate)),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Start Time
            InkWell(
              onTap: _pickStartTime,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffEFF0F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("${start.hour}:$startMin"), const Icon(Icons.keyboard_arrow_down)],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // End Time
            InkWell(
              onTap: _pickEndTime,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffEFF0F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("${end.hour}:$endMin"), const Icon(Icons.keyboard_arrow_down)],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Generate QR Button
            ElevatedButton(
              onPressed: _generateClass,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color(0xff5F2EEA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text("Generate QR", style: TextStyle(color: Color(0xffF7F7FC), fontFamily: "Poppins", fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickeddate,
    );
    if (date != null) setState(() => pickeddate = date);
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(context: context, initialTime: start);
    if (time != null) setState(() => start = time);
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(context: context, initialTime: end);
    if (time != null) setState(() => end = time);
  }

  Future<void> _generateClass() async {
    start1 = DateTime.parse(formatTimeOfDay(start, pickeddate));
    end1 = DateTime.parse(formatTimeOfDay(end, pickeddate));

    if (start1.isAfter(end1)) {
      Fluttertoast.showToast(
        msg: "Please check the timings",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12.0,
      );
    }

    final schema = ClassDetailSchema(classnameController.text, start1, end1, id);
    final body = json.encode(schema.toJson(), toEncodable: myEncode);

    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('YOUR_SERVER_ADD_CLASS_ENDPOINT'),
        headers: {"Content-Type": "application/json;charset=UTF-8"},
        body: body,
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      cid = data['cid'];

      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GeneratePage(pickeddate, start, end, classnameController.text, id, cid),
      ));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12.0,
      );
    } finally {
      client.close();
    }
  }
}
