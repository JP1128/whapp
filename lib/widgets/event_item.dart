import 'package:flutter/material.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';

class EventItem extends StatelessWidget {
  const EventItem(this.event, this.uid, {Key? key}) : super(key: key);

  final Event event;
  final String uid;

  @override
  Widget build(BuildContext context) {
    var avatar = event.eventType == EventType.attendance //
        ? attendanceAvatar
        : (event.eventType == EventType.volunteer //
            ? volunteerAvatar
            : const CircleAvatar());

    bool isFull = event.capacity! <= event.signUpsId!.length;
    bool isSignedUp = event.signUpsId!.contains(uid);

    var border = null;
    if (isSignedUp) border = Border.all(color: successColor.withAlpha(100), width: 3);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: border,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: palette[7].withAlpha(20),
            offset: Offset(0, 15),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatar,
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(event.start, "MMMM d, E"),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: palette[6]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    event.title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: event.end.isBefore(DateTime.now()) ? errorColor : palette[6],
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${formatDate(event.start, 'jm')} - ${formatDate(event.end, 'jm')}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: event.end.isBefore(DateTime.now()) ? errorColor : palette[6],
                            ),
                      )
                    ],
                  ),
                  if (event.eventType == EventType.volunteer)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: isFull ? errorColor.withAlpha(200) : palette[6],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${event.signUpsId!.length} / ${event.capacity}",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: isFull ? errorColor.withAlpha(200) : palette[6],
                              ),
                        ),
                      ],
                    )

                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Icon(
                  //       Icons.place_outlined,
                  //       color: palette[6],
                  //       size: 15,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     Text(
                  //       _event.location,
                  //       style: Get.textTheme.bodySmall!.copyWith(
                  //         color: palette[6],
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
