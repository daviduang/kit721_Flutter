import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'home.dart';
import 'models/feedEvent.dart';
import 'models/historyEvent.dart';
import 'models/nappyEvent.dart';
import 'models/sleepEvent.dart';

///
/// Main function for this App
///
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      // Providers for different models used in this app
      providers: [
        ChangeNotifierProvider(create: (context) => HistoryEventModel()),
        ChangeNotifierProvider(create: (context) => FeedEventModel()),
        ChangeNotifierProvider(create: (context) => NappyEventModel()),
        ChangeNotifierProvider(create: (context) => SleepEventModel()),
      ],
      child: MaterialApp(
        title: 'Welcome!',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(title: 'Welcome to My Baby Tracker!'),
      ),
    );
  }
}