import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/sleepEvent.dart';
import 'timerWidget.dart';
import 'customNavigationBar.dart';

///
/// Sleep event creation page
///
class SleepPage extends StatefulWidget {
  final String title;
  const SleepPage({Key? key, required this.title}) : super(key: key);

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final TextEditingController notesController = TextEditingController();

  // Initialize timer value
  int timerValue = 0;

  // create an instance of the SleepEventModel
  final SleepEventModel sleepEventModel = SleepEventModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {

              // Check if the timerValue is greater than 0
              if (timerValue == 0) {

                // Display a dialog if the timerValue is 0
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Invalid Input'),
                      content: const Text('Please start the timer before creating a Sleep Event.'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                // create a new SleepEvent
                SleepEvent newSleepEvent = SleepEvent(
                  title: 'Sleep Event',
                  duration: timerValue,
                  note: notesController.text,
                  timestamp: DateTime.now(),
                );

                // add the new SleepEvent to the database
                sleepEventModel.add(newSleepEvent).then((_) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              }
            },
          ),

        ],
      ),

      // A scroll view prevent the bottom overflow issue
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TimerWidget(
              onTimerChange: (value) {
                setState(() {
                  timerValue = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'My Notes',
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your notes here',
                    ),
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const CustomNavigationBar(initialIndex: 0),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    notesController.dispose();
    super.dispose();
  }
}