import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/feedEvent.dart';
import 'timerWidget.dart';
import 'segmentedButtonGroup.dart';
import 'customNavigationBar.dart';

///
/// Feed event creation page
///
class FeedPage extends StatefulWidget {
  final String title;
  const FeedPage({Key? key, required this.title}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController notesController = TextEditingController();

  // Initialize selected index
  int selectedTypeIndex = 0;

  // Initialize timer value
  int timerValue = 0;

  // Update the selected index when selection changed
  void onValueChanged(int index) {
    setState(() {
      selectedTypeIndex = index;
    });
  }

  // create an instance of the FeedEventModel
  final FeedEventModel feedEventModel = FeedEventModel();

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
              // Check if the timer has been used
              if (timerValue == 0) {
                // Display a dialog if the timer has not been used
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please use the timer before creating a feed event.'),
                      actions: <Widget>[
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
                // If the timer has been used, create a new FeedEvent
                FeedEvent newFeedEvent = FeedEvent(
                  title: 'Feed Event',
                  typeIndex: selectedTypeIndex,
                  duration: timerValue,
                  note: notesController.text,
                  timestamp: DateTime.now(),
                );

                // Add the new FeedEvent to the database
                feedEventModel.add(newFeedEvent).then((_) {
                  // Navigate the user to the home page
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
            // Timer widget
            TimerWidget(
              onTimerChange: (value) {
                setState(() {
                  timerValue = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Feeding side label
            const Text(
              'Feeding Type:',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),

            // Feeding side button group
            SegmentedButtonGroup(
              titles: const ['Breast Left', 'Breast Right', 'Bottle'],
              onValueChanged: onValueChanged,
            ),
            const SizedBox(height: 20),

            // Optional Notes section
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