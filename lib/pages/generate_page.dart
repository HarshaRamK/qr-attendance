import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class GeneratePage extends StatefulWidget {
  final DateTime date;
  final String cid;
  final TimeOfDay start;
  final TimeOfDay end;
  final String classname;
  final String id;

  const GeneratePage(this.date, this.start, this.end, this.classname, this.id, this.cid, {super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  late String qrData;

  @override
  void initState() {
    super.initState();
    qrData = formatTimeOfDay(widget.start, widget.date) +
        "," +
        formatTimeOfDay(widget.end, widget.date) +
        "," +
        widget.classname +
        "," +
        widget.id +
        "," +
        widget.cid;
  }

  String formatTimeOfDay(TimeOfDay tod, DateTime date) {
    final dt = DateTime(date.year, date.month, date.day, tod.hour, tod.minute);
    final format = DateFormat('yyyy-MM-dd HH:mm:ss');
    return format.format(dt);
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
          "QR ATTENDANCE SYSTEM",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              QrImageView(
                data: qrData,
                size: 300,
              ),
              const SizedBox(height: 30),
              const Divider(
                height: 20,
                thickness: 1,
                color: Color(0xff6C63FF),
                indent: 60,
                endIndent: 60,
              ),
              const SizedBox(height: 30),
              _infoRow('Class Name', widget.classname),
              _infoRow('Class Date', formatTimeOfDay(widget.start, widget.date).substring(0, 10)),
              _infoRow('Start Time', '${widget.start.hour}:${widget.start.minute.toString().padLeft(2, '0')}'),
              _infoRow('End Time', '${widget.end.hour}:${widget.end.minute.toString().padLeft(2, '0')}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _infoBox(label),
          _infoBox(value),
        ],
      ),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      height: 45,
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFC),
        border: Border.all(color: Colors.purple, width: 0.7),
      ),
      child: Center(child: Text(text, style: const TextStyle(fontFamily: 'Poppins'))),
    );
  }
}
