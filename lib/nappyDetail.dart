import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/nappyEvent.dart';
import 'segmentedButtonGroup.dart';
import 'customNavigationBar.dart';

///
/// Nappy Detail Page
///
class NappyDetailPage extends StatefulWidget {
  final String id;
  const NappyDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _NappyDetailPageState createState() => _NappyDetailPageState();
}

class _NappyDetailPageState extends State<NappyDetailPage> {
  final TextEditingController notesController = TextEditingController();

  // Fetch nappy event variables initialisation
  int selectedTypeIndex = 0;
  Future? fetchFuture;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    fetchFuture =
        Provider.of<NappyEventModel>(context, listen: false).fetch(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Nappy Event Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else {
          final nappyEvent = Provider
              .of<NappyEventModel>(context)
              .item;
          if (nappyEvent == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Nappy Event Details')),
              body: const Center(child: Text('No Nappy Event found')),
            );
          }

          // Initialising the selectedIndex with the fetched data.
          if (!isInitialized) {
            isInitialized = true;
            selectedTypeIndex = nappyEvent.typeIndex;
            notesController.text = nappyEvent.note;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Nappy Event Details'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {

                        // Alert dialog for users to confirm the edition
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

                            // When user confirm the nappy event edition
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                final model = Provider.of<NappyEventModel>(
                                    context, listen: false);
                                model.updateItem(
                                  widget.id,
                                  NappyEvent(
                                    title: nappyEvent.title,
                                    typeIndex: selectedTypeIndex,
                                    note: notesController.text,
                                    timestamp: nappyEvent.timestamp,
                                  ),
                                ).then((_) {
                                  Navigator.of(context).popUntil((
                                      route) => route.isFirst);
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
                        const Text(
                          'Nappy Type:',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 20),

                        // Nappy event type selection buttons
                        SegmentedButtonGroup(
                          titles: const ['Wet', 'Wet Dirty'],
                          onValueChanged: (value) {
                            setState(() {
                              selectedTypeIndex = value;
                            });
                          },
                          selectedIndex: selectedTypeIndex,
                        ),
                        const SizedBox(height: 20),

                        // Present the image if there is an image
                        if (nappyEvent.imageUrl != null && nappyEvent.imageUrl!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  'My Image',
                                  style: TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 20),
                                Image.network(nappyEvent.imageUrl!),
                              ],
                            ),
                          ),

                        // Optional notes
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
                            title: const Text('Delete Nappy Event'),
                            content: const Text(
                                'Are you sure you want to delete this Nappy Event?'),
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
                                  final model = Provider.of<NappyEventModel>(
                                      context, listen: false);
                                  model.delete(widget.id).then((_) {
                                    Navigator.of(context).popUntil((
                                        route) => route.isFirst);
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