import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: PomodoroTimerDemo(),
  ));
}

class PomodoroTimerDemo extends StatefulWidget {
  @override
  _PomodoroTimerDemoState createState() => _PomodoroTimerDemoState();
}

class _PomodoroTimerDemoState extends State<PomodoroTimerDemo> {
  Timer? timer;
  int workDuration = 25;
  int breakDuration = 5;
  int? currentDuration;
  bool isRunning = false;
  bool isWorkTime = true;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    if (currentDuration == null) {
      currentDuration = workDuration * 60;
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentDuration! <= 0) {
        if (isWorkTime) {
          currentDuration = breakDuration * 60;
        } else {
          currentDuration = workDuration * 60;
        }
        timer.cancel();
        isWorkTime = !isWorkTime;
        startTimer();
      } else {
        setState(() {
          currentDuration = currentDuration! - 1;
        });
      }
    });

    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      currentDuration = null;
    });
  }

  void editTimings(int workMinutes, int breakMinutes) {
    workDuration = workMinutes;
    breakDuration = breakMinutes;
    if (!isRunning) {
      currentDuration = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    String timerText = currentDuration == null
        ? '${strDigits(workDuration)}:00'
        : '${strDigits(currentDuration! ~/ 60)}:${strDigits(currentDuration! % 60)}';

    return Scaffold(
      backgroundColor: Color(0XFF1e1b2e),
      appBar: AppBar(
        title: Center(child: Text('Pomodoro')),
        backgroundColor: Color(0XFF1e1b2e),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF051960), Color(0xFF591DA9)],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                isWorkTime ? 'Focus' : 'Rest',
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                timerText,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 120,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(.0),
                      child: ElevatedButton(
                        onPressed: isRunning ? pauseTimer : startTimer,
                        child: Text(isRunning ? 'Pause' : 'Start',
                            style: TextStyle(fontSize: 20)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0XFF674fff)),
                          minimumSize: MaterialStateProperty.all(Size(150, 50)),
                        ),
                      ),
                    ),
                    if (isRunning)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: resetTimer,
                          child: Text('Reset', style: TextStyle(fontSize: 20)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0XFF674fff)),
                            minimumSize:
                                MaterialStateProperty.all(Size(150, 50)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0XFF674fff)),
                  minimumSize: MaterialStateProperty.all(Size(250, 80)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Timer Durations'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Work Minutes',
                              ),
                              onChanged: (value) {
                                workDuration =
                                    int.tryParse(value) ?? workDuration;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Break Minutes',
                              ),
                              onChanged: (value) {
                                breakDuration =
                                    int.tryParse(value) ?? breakDuration;
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Save'),
                            onPressed: () {
                              editTimings(workDuration, breakDuration);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Edit Durations', style: TextStyle(fontSize: 32)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
