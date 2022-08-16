import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/events/attendance.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/events/volunteer.dart';

class MemberItem extends StatefulWidget {
  MemberItem({
    Key? key,
    required this.fullName,
    required this.homeroom,
    required this.gradeLevel,
    required this.phoneNumber,
    required this.emailAddress,
  }) : super(key: key);

  String fullName;
  String homeroom;
  int gradeLevel;

  String phoneNumber;
  String emailAddress;

  @override
  State<MemberItem> createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  @override
  void initState() {
    super.initState();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.fullName} (${widget.gradeLevel})",
                style: Get.textTheme.titleSmall!.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    widget.emailAddress,
                    style: Get.textTheme.bodySmall!.copyWith(color: palette[6]),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone_outlined, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    parsePhoneNumber(widget.phoneNumber),
                    style: Get.textTheme.bodySmall!.copyWith(color: palette[6]),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Hr: ${widget.homeroom}",
                style: Get.textTheme.bodySmall!.copyWith(color: palette[6]),
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
