import 'package:flutter/material.dart';
import 'customNavigationBar.dart';
import 'feed.dart';
import 'sleep.dart';
import 'nappy.dart';

///
/// Home page
///
class Home extends StatefulWidget {

  final String title;
  const Home({Key? key, required this.title}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 3.5,
        padding: const EdgeInsets.all(20),
        mainAxisSpacing: 20,
        children: <Widget>[

          // Feed button lead to the Feed event creation page
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            icon: const Icon(Icons.fastfood),
            label: const Text("Feed", style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedPage(title: 'New Feed Event'),
                ),
              );
            },
          ),

          // Sleep button lead to the Sleep event creation page
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            icon: const Icon(Icons.bedtime),
            label: const Text("Sleep", style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SleepPage(title: 'New Sleep Event'),
                ),
              );
            },
          ),

          // Change Nappy button lead to the Nappy event creation page
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            icon: const Icon(Icons.child_care),
            label: const Text("Change Nappy", style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NappyPage(title: 'New Nappy Event'),
                ),
              );
            },
          ),

          // Sleep Alarm button (Customised feature)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            icon: const Icon(Icons.access_alarm),
            label: const Text("Sleep Alarm", style: TextStyle(fontSize: 20)),
            onPressed: () {
              // Navigate to the sleep alarm management page
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(initialIndex: 0),
    );
  }
}