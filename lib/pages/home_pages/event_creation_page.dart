import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/events_controller.dart';
import 'package:whapp/models/events/event.dart';

class EventCreationPage extends StatefulWidget {
  EventCreationPage({Key? key}) : super(key: key);

  final fk = GlobalKey<FormBuilderState>();

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final EventsController _ec = Get.find();

  late GlobalKey<FormBuilderState> _fk;

  var index = 0.obs;

  @override
  void initState() {
    super.initState();
    _fk = widget.fk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: defaultPadding,
        child: FormBuilder(
          child: Obx(() => IndexedStack(
                index: index.value,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Event type", style: Get.textTheme.displayLarge),
                      const SizedBox(height: 10),
                      Text("Select the event type", style: Get.textTheme.bodyMedium),
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _ec.eventType = EventType.volunteer;
                              index.value = index.value += 1;
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(palette.first),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  side: BorderSide(color: volunteerColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Volunteer",
                                        style: Get.textTheme.displayMedium!.copyWith(color: onVolunteerColor),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(Icons.volunteer_activism_rounded, color: onVolunteerColor),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Sign-ups are required to participate in the event.",
                                    style: Get.textTheme.bodyMedium!.copyWith(color: onVolunteerColor),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Members receive minutes and points "
                                    "based on how much of the event duration they participated.",
                                    style: Get.textTheme.bodyMedium!.copyWith(color: onVolunteerColor),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Event sign-up may be restricted on the basis of points, minutes, and collections.",
                                    style: Get.textTheme.bodyMedium!.copyWith(color: onVolunteerColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              _ec.eventType = EventType.attendance;
                              index.value = index.value += 1;
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(palette.first),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: BorderSide(color: attendanceColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                )),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Attendance",
                                        style: Get.textTheme.displayMedium!.copyWith(color: onAttendanceColor),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(Icons.check_rounded, color: onAttendanceColor),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Members receive minutes and points based on attendance.",
                                    style: Get.textTheme.bodyMedium!.copyWith(color: onAttendanceColor),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
