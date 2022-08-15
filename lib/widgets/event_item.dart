import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/events/attendance.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/events/volunteer.dart';

class EventItem extends StatefulWidget {
  const EventItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  late Event _event;
  late CircleAvatar _avatar;

  @override
  void initState() {
    super.initState();
    _event = widget.event;

    if (_event is VolunteerEvent) {
      _avatar = const CircleAvatar(
        backgroundColor: Color(0xFFB3EFB8),
        child: Icon(
          Icons.volunteer_activism_rounded,
          color: Color(0xFF39A542),
        ),
      );
    } else if (_event is AttendanceEvent) {
      _avatar = const CircleAvatar(
        backgroundColor: Color(0xFFF3F1B3),
        child: Icon(
          Icons.check_rounded,
          color: Color(0xFFC1BD58),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: palette[7].withAlpha(20),
            offset: Offset(0, 0),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar,
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(_event.start, "MMMM d, E"),
                    style: Get.textTheme.bodySmall!.copyWith(color: palette[6]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _event.title,
                    textAlign: TextAlign.left,
                    style: Get.textTheme.titleSmall!.copyWith(fontSize: 15),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: palette[6],
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${formatDate(_event.start, 'jm')} - ${formatDate(_event.end, 'jm')}",
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: palette[6],
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: palette[6],
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _event.location,
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: palette[6],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: palette[6],
          ),
        ],
      ),
    );
  }
}
