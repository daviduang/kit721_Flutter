import 'package:flutter/material.dart';
import 'dart:async';

///
/// The Timer module for feed event and sleep event
///
class TimerWidget extends StatefulWidget {
  final ValueChanged<int> onTimerChange;
  const TimerWidget({Key? key, required this.onTimerChange}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

// Define the corresponding State class
class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer; // Define a Timer object
  int _start = 0; // This integer is used to keep track of time passed
  bool _isPaused = true; // This boolean is used to toggle the timer

  // Function to start the timer
  void startTimer() {
    _isPaused = false;

    // This timer fires every second
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        if (!_isPaused) {

          // If timer is not paused, increment the _start value
          setState(() {
            _start++;

            // call the callback with the new value
            widget.onTimerChange(_start);
          });
        }
      },
    );
  }

  // Dispose function to cancel timer when not in use
  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),

        // The timer display, formatted as HH:MM:SS (From ChatGPT)
        Text(
            "${(_start ~/ 3600).toString().padLeft(2, '0')}:${((_start % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 30)
        ),

        // Grid layout for the timer control buttons
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          padding: const EdgeInsets.all(20),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: <Widget>[

            // Start/Pause button
            MaterialButton(
              color: _isPaused ? Theme.of(context).primaryColor : Colors.orange,
              onPressed: () {
                setState(() {
                  _isPaused = !_isPaused; // Toggle the _isPaused value
                });

                if (_isPaused && _timer.isActive) {
                  _timer.cancel(); // Pause the timer
                } else {
                  startTimer(); // Resume the timer
                }
              },
              child: Icon(_isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white, size: 50),
            ),

            // Reset button
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _start = 0; // Reset the timer

                  // Notify the timer value call back
                  widget.onTimerChange(_start);
                });
                if (!_isPaused) {
                  _timer.cancel(); // Stop the timer
                  _isPaused = true; // Set the timer state to paused
                }
              },
              child: const Icon(Icons.refresh, color: Colors.white, size: 50),
            ),
          ],
        ),
      ],
    );
  }
}