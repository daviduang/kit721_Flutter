import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/sleepEvent.dart';
import 'customNavigationBar.dart';

// Sleep Detail Page
class SleepDetailPage extends StatefulWidget {
  final String id;
  const SleepDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _SleepDetailPageState createState() => _SleepDetailPageState();
}

class _SleepDetailPageState extends State<SleepDetailPage> {
  final TextEditingController notesController = TextEditingController();
  Future? fetchFuture;
  bool isInitialized = false;

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingMinutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    fetchFuture = Provider.of<SleepEventModel>(context, listen: false).fetch(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sleep Event Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else {
          final sleepEvent = Provider.of<SleepEventModel>(context).item;
          if (sleepEvent == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Sleep Event Details')),
              body: const Center(child: Text('No Sleep Event found')),
            );
          }

          if (!isInitialized) {
            isInitialized = true;
            notesController.text = sleepEvent.note;
          }

          // Reformat the start time, end time and duration (From chatGPT)
          DateTime endTime = sleepEvent.timestamp;
          DateTime startTime = endTime.subtract(Duration(seconds: sleepEvent.duration));
          String formattedStartTime = DateFormat('HH:mm:ss').format(startTime);
          String formattedEndTime = DateFormat('HH:mm:ss').format(endTime);
          String formattedDate = DateFormat('yyyy-MM-dd').format(endTime);
          String duration = formatDuration(sleepEvent.duration);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Sleep Event Details'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Changes'),
                          content: const Text('Do you want to save changes?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),

                            // If user confirm the update
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                final model = Provider.of<SleepEventModel>(context, listen: false);
                                model.updateItem(
                                  widget.id,
                                  SleepEvent(
                                    title: sleepEvent.title,
                                    duration: sleepEvent.duration,
                                    note: notesController.text,
                                    timestamp: sleepEvent.timestamp,
                                  ),
                                ).then((_) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),


            body: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),

                        // Sleeping Date
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Date:', style: TextStyle(fontSize: 30)),
                              Text(formattedDate, style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),

                        // Sleeping start time
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Start Time:', style: TextStyle(fontSize: 30)),
                              Text(formattedStartTime, style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),

                        // Sleeping end time
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('End Time:', style: TextStyle(fontSize: 30)),
                              Text(formattedEndTime, style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),

                        // Sleeping Duration
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Duration:', style: TextStyle(fontSize: 30)),
                              Text(duration, style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Optional notes group
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
                ),

                // The delete button implementation
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                    child: const Text(
                      "Delete Event",
                      style: TextStyle(fontSize: 30),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Sleep Event'),
                            content: const Text('Are you sure you want to delete this Sleep Event?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () {
                                  final model = Provider.of<SleepEventModel>(context, listen: false);
                                  model.delete(widget.id).then((_) {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            bottomNavigationBar: const CustomNavigationBar(initialIndex: 1),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}