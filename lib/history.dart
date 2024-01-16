import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kit721_assignment4/sleepDetail.dart';
import 'package:provider/provider.dart';
import 'customNavigationBar.dart';
import 'feedDetail.dart';
import 'models/historyEvent.dart';
import 'nappyDetail.dart';

///
/// History items page for all events
///
class History extends StatefulWidget {
  final String title;

  const History({Key? key, required this.title}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  // A state to manage the sorting order
  bool isChronologicalOrder = true;

  // Change the sorting state of the history items
  void _sortHistory() {
    setState(() {
      isChronologicalOrder = !isChronologicalOrder;
    });
  }

  @override
  void initState() {
    super.initState();

    // Fetch data every time the page is loaded
    Provider.of<HistoryEventModel>(context, listen: false).fetch();
  }

  @override
  Widget build(BuildContext context) {
    var historyModel = Provider.of<HistoryEventModel>(context);

    if (historyModel.loading) {
      return Scaffold(
        appBar: AppBar(

          // Back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),

          // Page title
          title: Text(widget.title),
          centerTitle: true,

          // Sorting option menu
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (value) {
                _sortHistory();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Sort in chronological order'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Sort in reverse chronological order'),
                ),
              ],
            ),
          ],
        ),

        // Display the loading indicator
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {

      // Sort the history items list based on users choice
      var items = historyModel.items;
      items.sort((a, b) => isChronologicalOrder ? a.date.compareTo(b.date) : b.date.compareTo(a.date));

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.title),
          centerTitle: true,

          // The sorting option menu
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (value) {
                _sortHistory();
              },

              // Sorting options
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Sort in chronological order'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Sort in reverse chronological order'),
                ),
              ],
            ),
          ],
        ),

        // Build the list view
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {

            // Reformat the date (From chatGPT)
            String formattedDate = historyModel.items[index].date.toIso8601String().split('.')[0].replaceAll('T', ' ');

            return ListTile(
              title: Text(
                historyModel.items[index].title,
                style: const TextStyle(fontSize: 30),
              ),
              subtitle: Text(
                formattedDate,
                style: const TextStyle(fontSize: 25),
              ),
              onTap: () {

                // Navigate to the history event details page and pass the id
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // Fetch the event title
                      var eventTitle = historyModel.items[index].title;

                      // Depending on the event title, push different pages
                      if (eventTitle == 'Feed Event') {
                        return FeedDetailPage(id: historyModel.items[index].id);
                      } else if (eventTitle == 'Sleep Event') {
                        return SleepDetailPage(id: historyModel.items[index].id);
                      } else {
                        return NappyDetailPage(id: historyModel.items[index].id);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),

        bottomNavigationBar: const CustomNavigationBar(initialIndex: 1),
      );
    }
  }
}