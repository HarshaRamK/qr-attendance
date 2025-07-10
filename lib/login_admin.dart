import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_attendance_app/classdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginAdminPage extends StatefulWidget {
  @override
  _LoginAdminPageState createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  // Hardcoded faculty logins
  final Map<String, String> facultyLogins = {
    "teacher1@example.com": "pass123",
    "teacher2@example.com": "abc123",
    "teacher3@example.com": "teach789",
    "teacher4@example.com": "faculty4",
    "teacher5@example.com": "flutter5"
  };

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
          "",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SvgPicture.asset(
                "assets/admin_login.svg",
                height: 200,
                width: 181,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xffEFF0F6),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.mail_outline),
                    labelText: 'Teacher Email',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xffFCFCFC),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: Colors.purple, width: 0.7),
                ),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15.0),
                  backgroundColor: const Color(0xff5F2EEA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if (facultyLogins.containsKey(email) &&
                      facultyLogins[email] == password) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ClassDetailsPage(email),
                    ));
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Invalid email or password',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      fontSize: 12.0,
                    );
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Color(0xffF7F7FC),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
