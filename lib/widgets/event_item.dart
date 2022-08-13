import 'package:flutter/material.dart';
import 'package:whapp/models/event.dart';

Widget buildEventItem(Event event) {
  return SizedBox(
    height: 70.0,
    child: Card(
      child: Column(
        children: [
          Text(event.title),
          Text(event.location),
          Text(event.start.hour.toString()),
          Text(event.start.hour.toString()),
        ],
      ),
    ),
  );
}
