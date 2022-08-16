import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/controllers/events_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/events/attendance.dart';
import 'package:whapp/models/events/event.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final AuthController _ac = Get.find();
  final EventsController _ec = Get.find();

  late Event _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(actions: [
            if (_ac.isBoard())
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(
                      "Edit",
                      style: Get.textTheme.titleSmall,
                    ),
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Delete",
                      style: Get.textTheme.titleSmall,
                    ),
                    onTap: () {
                      _ec.deleteEvent(_event);
                      Get.back();
                    },
                  ),
                ],
              ),
          ]),
          body: SingleChildScrollView(
            child: Container(
              padding: defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_event.boardOnly)
                    Text(
                      "Board member only",
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: palette[6],
                      ),
                    ),
                  Text(
                    _event.title,
                    style: Get.textTheme.displayLarge,
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: palette[6],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatDate(_event.start, "MMMM d, EEEE"),
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: palette[6],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: palette[6],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${formatDate(_event.start, 'jm')} - ${formatDate(_event.end, 'jm')} (${_event.end.difference(_event.start).inMinutes} minutes)",
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: palette[6],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: palette[6],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _event.location,
                        style: Get.textTheme.bodyMedium!.copyWith(
                          color: palette[6],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Description",
                    style: Get.textTheme.titleMedium!.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(_event.description ?? "No description", style: Get.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RawMaterialButton(
                  child: const Icon(Icons.group_rounded),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  constraints: BoxConstraints(minWidth: 60, minHeight: 50),
                  // padding: const EdgeInsets.all(5),
                  shape: const CircleBorder(),
                  onPressed: () {},
                ),
                RawMaterialButton(
                  child: const Icon(
                    Icons.attach_money_outlined,
                    color: Color.fromARGB(255, 238, 216, 21),
                  ),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  constraints: BoxConstraints(minWidth: 60, minHeight: 50),
                  // padding: const EdgeInsets.all(5),
                  shape: const CircleBorder(),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Sign up"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
