import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Data model for all events
class HistoryEvent {
  late String id;
  String title;
  DateTime date;

  HistoryEvent({required this.title, required this.date});

  HistoryEvent.fromJson(Map<String, dynamic> json, this.id)
      : this.title = json['title'],
        this.date = DateTime.parse(json['timestamp']);

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'timestamp': date.toIso8601String(),
      };
}

class HistoryEventModel extends ChangeNotifier {
  final List<HistoryEvent> items = [];
  CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');
  bool loading = false;

  HistoryEventModel() {
    fetch();
  }

  // Delete history event by id
  Future delete(String id) async {
    loading = true;
    update();

    await eventCollection.doc(id).delete();

    await fetch();
  }

  void update() {
    notifyListeners();
  }

  // Fetch all history events
  Future fetch() async {

    // clear items before fetching
    items.clear();
    loading = true;
    notifyListeners();

    var querySnapshot = await eventCollection.orderBy("title").get();

    for (var doc in querySnapshot.docs) {
      var historyEvent = HistoryEvent.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      items.add(historyEvent);
    }

    loading = false;
    update();
  }

  // Fetch all history events in a specific date
  Future fetchByDate(DateTime date) async {
    items.clear();
    loading = true;
    notifyListeners();

    var start = DateTime(date.year, date.month, date.day);
    var end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    var querySnapshot = await eventCollection
        .orderBy("timestamp")
        .startAt([start.toIso8601String()])
        .endAt([end.toIso8601String()])
        .get();

    for (var doc in querySnapshot.docs) {
      var historyEvent = HistoryEvent.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      items.add(historyEvent);
    }

    loading = false;
    update();
  }

  HistoryEvent? get(String? id) {
    if (id == null) return null;
    return items.firstWhere((event) => event.id == id);
  }
}