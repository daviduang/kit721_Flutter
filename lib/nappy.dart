import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/nappyEvent.dart';
import 'segmentedButtonGroup.dart';
import 'customNavigationBar.dart';

///
/// Nappy event creation page
///
class NappyPage extends StatefulWidget {
  final String title;
  const NappyPage({Key? key, required this.title}) : super(key: key);

  @override
  _NappyPageState createState() => _NappyPageState();
}

class _NappyPageState extends State<NappyPage> {
  final TextEditingController notesController = TextEditingController();

  // Initialize selected index
  int selectedTypeIndex = 0;

  // Initialize the image and image picker
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // Update the selected index when selection changed
  void onValueChanged(int index) {
    setState(() {
      selectedTypeIndex = index;
    });
  }

  // Get image method
  Future getImage() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }

  // create an instance of the NappyEventModel
  final NappyEventModel nappyEventModel = NappyEventModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // create a new NappyEvent
              NappyEvent newNappyEvent = NappyEvent(
                title: 'Nappy Event',
                typeIndex: selectedTypeIndex,
                note: notesController.text,
                timestamp: DateTime.now(),
              );

              // add the new NappyEvent to the database
              await nappyEventModel.add(newNappyEvent, _image).then((_) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },

          ),
        ],
      ),

      // A scroll view prevent the bottom overflow issue
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),

            // Nappy type button group
            const Text(
              'Nappy Type:',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            SegmentedButtonGroup(
                titles: const ['Wet', 'Wet Dirty'],
                onValueChanged: onValueChanged
            ),
            const SizedBox(height: 20),

            // Show selected image if one has been selected
            if (_image != null)
              if (_image != null)
                Image.file(
                  _image!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
            const SizedBox(height: 20),

            // Image selection button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: getImage,
                  child: const Text(
                    'Select a photo',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Optional note
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

      // Bottom Navigation Bar
      bottomNavigationBar: const CustomNavigationBar(initialIndex: 0),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    notesController.dispose();
    super.dispose();
  }
}