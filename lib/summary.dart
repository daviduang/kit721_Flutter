import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'customNavigationBar.dart';
import 'models/feedEvent.dart';
import 'models/historyEvent.dart';
import 'models/nappyEvent.dart';
import 'models/sleepEvent.dart';

///
/// Summary page
///
class Summary extends StatefulWidget {
  final String title;
  const Summary({Key? key, required this.title}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {

  // Initialise the event list by current date
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _fetchEventDetails();
    });
  }

  // Initialise the selected date by the current date
  DateTime selectedDate = DateTime.now();

  // Initialise the summary variables
  int leftSideFeedingDuration = 0;
  int rightSideFeedingDuration = 0;
  int sleepingDuration = 0;
  int wetNappyCount = 0;
  int wetDirtyNappyCount = 0;

  // Date picker method (From ChatGPT)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Fetch the event data from database
      await _fetchEventDetails();
    }
  }

  // Fetch the event history by a specific date and assign the data into summary variables
  Future<void> _fetchEventDetails() async {
    // Fetch the data from the selected date
    final historyEventModel = Provider.of<HistoryEventModel>(
        context, listen: false);
    await historyEventModel.fetchByDate(selectedDate);

    // Initialize event models
    FeedEventModel feedEventModel = FeedEventModel();
    NappyEventModel nappyEventModel = NappyEventModel();
    SleepEventModel sleepEventModel = SleepEventModel();

    // Calculate event details
    int leftSideFeeding = 0;
    int rightSideFeeding = 0;
    int sleeping = 0;
    int wetNappy = 0;
    int wetDirtyNappy = 0;

    for (var event in historyEventModel.items) {
      switch (event.title) {
        case 'Feed Event':

          // Fetch feed event
          await feedEventModel.fetch(event.id);
          FeedEvent feedEvent = feedEventModel.item!;

          // Assign the duration for each feeding type
          if (feedEvent.typeIndex == 0) {
            leftSideFeeding += feedEvent.duration;
          } else if (feedEvent.typeIndex == 1) {
            rightSideFeeding += feedEvent.duration;
          }

          break;
        case 'Nappy Event':

          // Fetch nappy event
          await nappyEventModel.fetch(event.id);
          NappyEvent nappyEvent = nappyEventModel.item!;

          // Assign the duration for each nappy type
          if (nappyEvent.typeIndex == 0) {
            wetNappy += 1;
          } else {
            wetDirtyNappy += 1;
          }

          break;
        case 'Sleep Event':

          // Fetch sleep event
          await sleepEventModel.fetch(event.id);
          SleepEvent sleepEvent = sleepEventModel.item!;

          // Assign the duration
          sleeping += sleepEvent.duration;
          break;
      }
    }

    // Update the state
    setState(() {
      leftSideFeedingDuration = leftSideFeeding;
      rightSideFeedingDuration = rightSideFeeding;
      sleepingDuration = sleeping;
      wetNappyCount = wetNappy;
      wetDirtyNappyCount = wetDirtyNappy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        // Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // Page Title
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [

            // Date picker
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.calendar_today, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Select date:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat.yMd().format(selectedDate),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) =>
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),

                      // Feed and Sleep Event Summary tables
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Event')),
                          DataColumn(label: Text('Duration')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text('Left Side Feeding')),
                              DataCell(Text(
                                  Duration(seconds: leftSideFeedingDuration)
                                      .toString()
                                      .split('.')
                                      .first
                                      .padLeft(8, "0"))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('Right Side Feeding')),
                              DataCell(Text(
                                  Duration(seconds: rightSideFeedingDuration)
                                      .toString()
                                      .split('.')
                                      .first
                                      .padLeft(8, "0"))),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('Sleep')),
                              DataCell(Text(Duration(seconds: sleepingDuration)
                                  .toString()
                                  .split('.')
                                  .first
                                  .padLeft(8, "0"))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) =>
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    // Nappy Event Summary tables
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Event')),
                          DataColumn(label: Text('Total Number')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text('Wet Nappy')),
                              DataCell(Text('$wetNappyCount')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('Wet Dirty Nappy')),
                              DataCell(Text('$wetDirtyNappyCount')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 20),

            // Share button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // set the color of the button
                  primary: Colors.green,
                ),
                child: const Text(
                  "Share",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                onPressed: () {

                  // Build a string containing your summary data (From chatGPT)
                  String summaryData =
                      'Summary Data: \n\nLeft Side Feeding: '
                      '${Duration(seconds: leftSideFeedingDuration).toString().split('.').first.padLeft(8, "0")}\n'
                      'Right Side Feeding: ${Duration(seconds: rightSideFeedingDuration).toString().split('.').first.padLeft(8, "0")}\n'
                      'Sleep: ${Duration(seconds: sleepingDuration).toString().split('.').first.padLeft(8, "0")}\n'
                      'Wet Nappy: $wetNappyCount\n'
                      'Wet Dirty Nappy: $wetDirtyNappyCount\n';

                  // Share the summary data
                  Share.share(summaryData);
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigator
      bottomNavigationBar: const CustomNavigationBar(initialIndex: 2),
    );
  }
}