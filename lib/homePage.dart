import 'package:flutter/material.dart';
import 'package:qr_attendance_app/login_student.dart';
import 'package:qr_attendance_app/login_admin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              Image.asset("assets/home.png", height: 340, width: 181),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    flatButton("Login for Student", LoginStudentPage()),
                    const SizedBox(height: 50),
                    const Divider(
                      height: 10,
                      thickness: 1.0,
                      color: Color(0xff6C63FF),
                      indent: 80,
                      endIndent: 80,
                    ),
                    const SizedBox(height: 50),
                    flatButton("Login for Teacher", LoginAdminPage()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff5F2EEA),
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
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
