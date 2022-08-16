import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/controllers/events_controller.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/pages/home_pages/event_detail_page.dart';
import 'package:whapp/widgets/event_item.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final AuthController _ac = Get.find();
  final EventsController _ec = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Explore"),
          actions: [
            if (_ac.isBoard())
              IconButton(
                onPressed: () => Get.toNamed("/create_event"),
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<List<Event>> lsts = snapshots.data!;

            var stream = [
              ...lsts[0],
              ...lsts[1],
            ];

            stream.sort((a, b) => a.start.isBefore(b.start) ? 0 : 1);

            if (!_ac.isBoard()) {
              stream.retainWhere((element) => !element.boardOnly);
            }

            if (stream.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(50),
                child: Center(
                  child: Text(
                    "There is no more upcoming event :(",
                    textAlign: TextAlign.center,
                    style: Get.textTheme.titleMedium!.copyWith(color: palette[5]),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              itemCount: stream.length,
              itemBuilder: ((context, index) {
                var event = stream[index];
                return GestureDetector(
                  child: EventItem(event: event),
                  onTap: () => Get.to(() => EventDetailPage(event: event)),
                );
              }),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
            );
          },
        ),
      ),
    );
  }
}
