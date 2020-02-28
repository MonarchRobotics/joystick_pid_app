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


  MotorControlPID pid = MotorControlPID(0.0,1.0,1.0,0.2,0.017,0);

  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          RaisedButton(
            child: Text("Reset"),
            onPressed: (){
              setState((){
                pid.reset();
                previousSpeed = 0;
                joystickReading = 0;
              });
            },
          )
        ],
      ),
    );
  }
}
