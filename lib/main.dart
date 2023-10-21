import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: CountdownTimerDemo(),
  ));
}

class CountdownTimerDemo extends StatefulWidget {
  @override
  _CountdownTimerDemoState createState() => _CountdownTimerDemoState();
}

class _CountdownTimerDemoState extends State<CountdownTimerDemo> {
  Timer? countdownTimer;
  Timer? otpTimer;
  Duration countdownDuration = Duration(hours: 1); //Duration(days: 5);
  Duration otpDuration = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
  }

  void startCountdownTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountdown());
  }

  void stopCountdownTimer() {
    setState(() => countdownTimer?.cancel());
  }

  void resetCountdownTimer() {
    stopCountdownTimer();
    setState(() => countdownDuration = Duration(hours: 1));
  }

  void setCountdown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = countdownDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer?.cancel();
      } else {
        countdownDuration = Duration(seconds: seconds);
      }
    });
  }

  void startOtpTimer() {
    otpTimer = Timer.periodic(Duration(seconds: 1), (_) => setOtpCountdown());
  }

  void stopOtpTimer() {
    setState(() => otpTimer?.cancel());
  }

  void resetOtpTimer() {
    stopOtpTimer();
    setState(() => otpDuration = Duration(minutes: 2));
  }

  void setOtpCountdown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = otpDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        otpTimer?.cancel();
      } else {
        otpDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final countdownDays = strDigits(countdownDuration.inDays);
    final countdownHours = strDigits(countdownDuration.inHours.remainder(24));
    final countdownMinutes =
        strDigits(countdownDuration.inMinutes.remainder(60));
    final countdownSeconds =
        strDigits(countdownDuration.inSeconds.remainder(60));

    final otpSeconds = strDigits(otpDuration.inSeconds);

    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timers'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            // NORMAL COUNTDOWN PART ----------------------------------------------------
            Text(
              'Countdown Timer:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$countdownDays:$countdownHours:$countdownMinutes:$countdownSeconds',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            ElevatedButton(
              onPressed: startCountdownTimer,
              child: Text('Start Countdown'),
            ),
            ElevatedButton(
              onPressed: stopCountdownTimer,
              child: Text('Stop Countdown'),
            ),
            ElevatedButton(
              onPressed: resetCountdownTimer,
              child: Text('Reset Countdown'),
            ),
            SizedBox(
              height: 20,
            ),
            // OTP PART ----------------------------------------------------------
            Text(
              'OTP Countdown Timer:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Time Remaining: $otpSeconds seconds',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            ElevatedButton(
              onPressed: startOtpTimer,
              child: Text('Send OTP'),
            ),
            ElevatedButton(
              onPressed: stopOtpTimer,
              child: Text('Stop OTP'),
            ),
            ElevatedButton(
              onPressed: resetOtpTimer,
              child: Text('Reset OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
