import 'package:flutter/material.dart';

///
/// Segmented button group for type event type selection:
///   Feed event: Left, Right and Bottle
///   Nappy Event: Wet and Wet Dirty
///
class SegmentedButtonGroup extends StatefulWidget {
  final List<String> titles;
  final ValueChanged<int> onValueChanged;
  final int selectedIndex;

  const SegmentedButtonGroup({
    Key? key,
    required this.titles,
    required this.onValueChanged,
    this.selectedIndex = 0, // default to 0 if not provided (From ChatGPT)
  }) : super(key: key);

  @override
  _SegmentedButtonGroupState createState() => _SegmentedButtonGroupState();
}

class _SegmentedButtonGroupState extends State<SegmentedButtonGroup> {
  // Store the selected index
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    // Set the initial value for selectedIndex when the widget is first created
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(SegmentedButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the selected index has been updated from the parent widget, then update the state
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        selectedIndex = widget.selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Returns a row of buttons with the selected button highlighted
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: List<Widget>.generate(
          widget.titles.length,
              (index) => Expanded(
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  // Change button color based on the selected index
                  color: selectedIndex == index ? Colors.blue : Colors.grey,
                  onPressed: () {
                    setState(() {
                      // Update selectedIndex when a button is pressed
                      selectedIndex = index;
                    });
                    // Pass the updated index to the callback function
                    widget.onValueChanged(index);
                  },
                  child: Text(
                    widget.titles[index],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}