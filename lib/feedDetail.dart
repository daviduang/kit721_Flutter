import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/feedEvent.dart';
import 'segmentedButtonGroup.dart';
import 'customNavigationBar.dart';

///
/// Feed detail page
///
class FeedDetailPage extends StatefulWidget {
  final String id;
  const FeedDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _FeedDetailPageState createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  final TextEditingController notesController = TextEditingController();
  int selectedTypeIndex = 0;
  int storedTypeIndex = 0;
  bool isInitialized = false;
  Future? fetchFuture;

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingMinutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    fetchFuture = Provider.of<FeedEventModel>(context, listen: false).fetch(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Feed Event Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else {
          final feedEvent = Provider.of<FeedEventModel>(context).item;
          if (feedEvent == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Feed Event Details')),
              body: const Center(child: Text('No Feed Event found')),
            );
          }

          if (!isInitialized) {
            storedTypeIndex = feedEvent.typeIndex;
            selectedTypeIndex = storedTypeIndex;
            isInitialized = true;
            notesController.text = feedEvent.note;
          }

          // Reformat the start time, end time and duration (From chatGPT)
          DateTime endTime = feedEvent.timestamp;
          DateTime startTime = endTime.subtract(Duration(seconds: feedEvent.duration));
          String formattedStartTime = DateFormat('HH:mm:ss').format(startTime);
          String formattedEndTime = DateFormat('HH:mm:ss').format(endTime);
          String formattedDate = DateFormat('yyyy-MM-dd').format(endTime);
          String duration = formatDuration(feedEvent.duration);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Feed Event Details'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {

                        // Editing confirmation dialog alert
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

                            // If user confirm the edition
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                final model = Provider.of<FeedEventModel>(context, listen: false);
                                model.updateItem(
                                  widget.id,
                                  FeedEvent(
                                    title: feedEvent.title,
                                    typeIndex: selectedTypeIndex,
                                    duration: feedEvent.duration,
                                    note: notesController.text,
                                    timestamp: feedEvent.timestamp,
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

                        // Displaying date
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

                        // Displaying start time
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

                        // Displaying end time
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

                        // Displaying Duration
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

                        // Feeding type segmented group
                        const Text(
                          'Feeding Type:',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 20),
                        SegmentedButtonGroup(
                          titles: const ['Breast Left', 'Breast Right', 'Bottle'],
                          onValueChanged: (value) {
                            setState(() {
                              selectedTypeIndex = value;
                            });
                          },
                          selectedIndex: selectedTypeIndex,
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
                ),

                // The delete button implementation
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      // set the color of the button
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
                            title: const Text('Delete Feed Event'),
                            content: const Text('Are you sure you want to delete this Feed Event?'),
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
                                  final model = Provider.of<FeedEventModel>(context, listen: false);
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