import 'dart:async';

import 'package:flutter/material.dart';
import 'package:joystick_pid_test/motor_control_pid.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joystick PID Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main()
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  double joystickReading = 0.0;

  double speedOutput = 0.0;
  double previousSpeed = 0.0;
  List<double> speedList = List();

  TextEditingController KpText;
  TextEditingController KiText;
  TextEditingController KdText;


  MotorControlPID pid;

  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    KpText = TextEditingController(text: "0.2");
    KiText = TextEditingController(text: "0.03");
    KdText = TextEditingController(text: "0.0");

    pid = MotorControlPID(0.0,1.0,1.0,0.2,0.03,0.0);

    timer = Timer.periodic(Duration(milliseconds: 20), (Timer timer){
      setState(() {
        pid.setTarget(joystickReading);
        speedOutput = pid.getSpeed(previousSpeed);
        previousSpeed = speedOutput;
        speedList.add(speedOutput);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joystick PID Test"),
      ),
      body: ListView(
        children: <Widget>[
          Text("Joystick reading:"),
          Slider(
            value: joystickReading,
            max: 1.0,
            min: -1.0,
            onChanged: (double newValue){
              joystickReading = newValue;
            },
          ),
          Text("Speed Output (after PID):"),
          Slider(
            value: speedOutput,
            max: 1.0,
            min: -1.0,
            onChanged: (double newValue){
            },
          ),
          Text("Kp:"),
          TextField(
            controller: KpText,
            onChanged: (String text){
              pid.setKp(double.parse(text));
              pid.reset();
              previousSpeed = 0;
              joystickReading = 0;
            },
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
          Text("Ki:"),
          TextField(
            controller: KiText,
            onChanged: (String text){
              pid.setKi(double.parse(text));
              pid.reset();
              previousSpeed = 0;
              joystickReading = 0;
            },
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
          Text("Kd:"),
          TextField(
            controller: KdText,
            onChanged: (String text){
              pid.setKd(double.parse(text));
              pid.reset();
              previousSpeed = 0;
              joystickReading = 0;
            },
            keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
          RaisedButton(
            child: Text("Reset"),
            onPressed: (){
              setState((){
                pid.reset();
                previousSpeed = 0;
                joystickReading = 0;
              });
            },
          ),
        ],
      ),
    );
  }
}
