import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A data model representing a feed event
class FeedEvent {
  String? id;
  String title;
  int typeIndex = 0;
  String note;
  int duration = 0;
  DateTime timestamp;

  FeedEvent({required this.title, required this.typeIndex, required this.duration, required this.note, required this.timestamp});

  // Convert a feed event from JSON format
  FeedEvent.fromJson(Map<String, dynamic> json, this.id)
      : title = json['title'],
        typeIndex = json['typeIndex'],
        note = json['note'],
        duration = json['duration'] ?? 0,
        timestamp = DateTime.parse(json['timestamp']);

  // Convert a feed event to JSON format
  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'typeIndex': typeIndex,
        'duration' : duration,
        'note': note,
        'timestamp': timestamp.toIso8601String(),
      };
}

// A data model representing the collection of all feed events
class FeedEventModel extends ChangeNotifier {
  FeedEvent? item;
  bool loading = false;

  // Firebase functions (add, update, delete)

  // Add a new feed event
  Future add(FeedEvent item) async {
    loading = true;
    update();

    // Get the id of the new event
    DocumentReference docRef = await FirebaseFirestore.instance.collection('events').add(item.toJson());
    String newId = docRef.id;
    await fetch(newId);
  }

  // Update a feed event by ID
  Future updateItem(String id, FeedEvent item) async {
    loading = true;
    update();

    await FirebaseFirestore.instance.collection('events').doc(id).set(item.toJson());
    await fetch(id);
  }

  // Delete a feed event by ID
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

  // Fetch a feed event by ID
  Future fetch(String id) async {
    loading = true;
    notifyListeners();

    var doc = await FirebaseFirestore.instance.collection('events').doc(id).get();
    item = FeedEvent.fromJson(doc.data()!, doc.id);

    loading = false;
    update();
  }
}