import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A data model representing a sleep event
class SleepEvent {
  String? id;
  String title;
  String note;
  int duration = 0;
  DateTime timestamp;

  SleepEvent({required this.title, required this.duration, required this.note, required this.timestamp});

  // Convert a sleep event from JSON format
  SleepEvent.fromJson(Map<String, dynamic> json, this.id)
      : title = json['title'],
        note = json['note'],
        duration = json['duration'],
        timestamp = DateTime.parse(json['timestamp']);

  // Convert a sleep event to JSON format
  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'duration' : duration,
        'note': note,
        'timestamp': timestamp.toIso8601String(),
      };
}

// A data model representing the collection of all sleep events
class SleepEventModel extends ChangeNotifier {
  SleepEvent? item;
  bool loading = false;

  // Firebase functions (add, update, delete)

  // Add a new sleep event
  Future add(SleepEvent item) async {
    loading = true;
    update();

    // Get the id of the new event
    DocumentReference docRef = await FirebaseFirestore.instance.collection('events').add(item.toJson());
    String newId = docRef.id;
    await fetch(newId);
  }

  // Update a sleep event by ID
  Future updateItem(String id, SleepEvent item) async {
    loading = true;
    update();

    await FirebaseFirestore.instance.collection('events').doc(id).set(item.toJson());
    await fetch(id);
  }

  // Delete a sleep event by ID
  Future delete(String id) async {
    loading = true;
    update();

    await FirebaseFirestore.instance.collection('events').doc(id).delete();
    item = null;

    loading = false;
    update();
  }

  void update() {
    notifyListeners();
  }

  // Fetch a sleep event by ID
  Future fetch(String id) async {
    loading = true;
    notifyListeners();

    var doc = await FirebaseFirestore.instance.collection('events').doc(id).get();
    item = SleepEvent.fromJson(doc.data()! as Map<String, dynamic>, doc.id);

    loading = false;
    update();
  }
}