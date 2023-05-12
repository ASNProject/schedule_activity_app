import 'package:flutter/material.dart';
import 'package:schedule_activity_app/features/widget/set_time_schedule.dart';

class Homepage extends StatefulWidget {
  final String title;
  const Homepage({
    super.key,
    required this.title,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: _buildLoadView(),
    );
  }

  _buildLoadView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            SetTimeSchedule()
          ],
        ),
      ),
    );
  }
}
