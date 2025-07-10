import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AttendancePage extends StatefulWidget {
  final Map attendance;

  AttendancePage(this.attendance);

  @override
  _AttendancePageState createState() => _AttendancePageState(attendance);
}

class _AttendancePageState extends State<AttendancePage> {
  Map attendance;

  _AttendancePageState(this.attendance);

  Color getColor(int percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 40) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.5, 1],
              colors: [Color(0xff661EFF), Color(0xffFFA3FD)],
            ),
          ),
        ),
        title: Text(
          "Attendance",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: attendance.length,
            itemBuilder: (BuildContext context, int index) {
              String key1 = attendance.keys.elementAt(index);
              int value = attendance[key1];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 75,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Color(0xff661EFF),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: Text(
                          '$key1 :',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 130,
                      width: 198,
                      padding: EdgeInsets.only(left: 15),
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 10.0,
                          percent: (value.toDouble()) / 100,
                          backgroundColor: Colors.grey[400]!,
                          progressColor: getColor(value),
                          center: Text('${value.toDouble().toStringAsFixed(2)}%'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
