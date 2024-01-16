import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// A data model representing a nappy event
class NappyEvent {
  String? id;
  String title;
  int typeIndex = 0;
  String note;

  // store the image URL
  String? imageUrl;
  DateTime timestamp;

  NappyEvent({required this.title, required this.typeIndex, required this.note, required this.timestamp, this.imageUrl});

  // Convert a nappy event from JSON format
  NappyEvent.fromJson(Map<String, dynamic> json, this.id)
      : title = json['title'],
        typeIndex = json['typeIndex'],
        note = json['note'],
        imageUrl = json['imageUrl'], // parse the image URL
        timestamp = DateTime.parse(json['timestamp']);

  // Convert a nappy event to JSON format
  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'typeIndex': typeIndex,
        'note': note,
        'imageUrl': imageUrl, // include the image URL
        'timestamp': timestamp.toIso8601String(),
      };
}

// A data model representing the collection of all nappy events
class NappyEventModel extends ChangeNotifier {
  NappyEvent? item;
  bool loading = false;

  // Firebase functions (add, update, delete)

  // Add a new nappy event
  Future add(NappyEvent item, [File? image]) async {
    loading = true;
    update();

    // Upload the image and get the download URL
    String? imageUrl;
    if (image != null) {
      imageUrl = await uploadImage(image);
    }

    // Add the download URL to the item
    item.imageUrl = imageUrl;

    // Get the id of the new event
    DocumentReference docRef = await FirebaseFirestore.instance.collection('events').add(item.toJson());
    String newId = docRef.id;
    await fetch(newId);
  }

  // Update a nappy event by ID
  Future updateItem(String id, NappyEvent item, [File? image]) async {
    loading = true;
    update();

    // Upload the image and get the download URL
    String? imageUrl;
    if (image != null) {
      imageUrl = await uploadImage(image);
    }

    // Update the download URL in the item
    item.imageUrl = imageUrl;

    await FirebaseFirestore.instance.collection('events').doc(id).set(item.toJson());
    await fetch(id);
  }

  // Delete a nappy event by ID
  Future delete(String id) async {
    loading = true;
    update();

    var doc = await FirebaseFirestore.instance.collection('events').doc(id).get();
    String? imageUrl = doc.data()!['imageUrl'];

    // Delete the image from Firebase Storage
    if (imageUrl != null) {
      await deleteImage(imageUrl);
    }

    await FirebaseFirestore.instance.collection('events').doc(id).delete();
    item = null;

    loading = false;
    update();
  }

  // Delete the associated image of the nappy event
  Future<void> deleteImage(String imageUrl) async {
    Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
    await ref.delete();
  }

  void update() {
    notifyListeners();
  }

  // Fetch a nappy event by ID
  Future fetch(String id) async {
    loading = true;
    notifyListeners();

    var doc = await FirebaseFirestore.instance.collection('events').doc(id).get();
    item = NappyEvent.fromJson(doc.data()! as Map<String, dynamic>, doc.id);

    loading = false;
    update();
  }

  // Upload a file to Firebase Storage and return the download URL (From ChatGPT)
  Future<String> uploadImage(File image) async {
    // Create a reference to the location you want to upload to in firebase
    Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}');

    // Upload the file to firebase
    UploadTask uploadTask = ref.putFile(image);

    // Waits till the file is uploaded then stores the download URL
    final String downloadURL = await (await uploadTask).ref.getDownloadURL();

    // Returns the download URL
    return downloadURL;
  }
}