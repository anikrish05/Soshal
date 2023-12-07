import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  final bool isSlidingPanelVisible;

  const SlidingUpWidget({required this.isSlidingPanelVisible});

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  double _panelHeightClosed = 0.0;
  double _panelHeightOpened = 200.0;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: _buildPanelContent(),
      minHeight: _panelHeightClosed,
      maxHeight: _panelHeightOpened,
      body: Container(), // Empty container to prevent interference with the underlying map
    );
  }

  Widget _buildPanelContent() {
    if (widget.isSlidingPanelVisible) {
      return Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'This is the sliding panel content.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Empty container if the panel is not visible
    }
  }
}
