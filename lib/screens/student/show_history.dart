import 'package:flutter/material.dart';

class ShowHistory extends StatefulWidget {
  const ShowHistory({super.key});

  @override
  State<ShowHistory> createState() => _ShowHistoryState();
}

class _ShowHistoryState extends State<ShowHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
// show list of all attendance marked by students, with date, time, within range or not, penalty applied or not