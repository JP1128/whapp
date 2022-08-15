import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/controllers/events_controller.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/events/volunteer.dart';
import 'package:whapp/widgets/event_item.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  EventsController _ec = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _ec.getEvents(),
        builder: (
          context,
          AsyncSnapshot<List<List<Event>>> snapshots,
        ) {
          if (!snapshots.hasData) {
            return Text("Nothing");
          }

          List<List<Event>> lsts = snapshots.data!;

          var stream = [
            ...lsts[0],
            ...lsts[1],
          ];

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
            itemCount: stream.length,
            itemBuilder: ((context, index) {
              var event = stream[index];
              return EventItem(event: event);
            }),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          );
        },
      ),
    );
  }
}
