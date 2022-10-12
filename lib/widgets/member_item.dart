import 'package:flutter/material.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';

class MemberItem extends StatelessWidget {
  const MemberItem(
    this.uid,
    this.fullName,
    this.homeroom,
    this.gradeLevel,
    this.phoneNumber,
    this.emailAddress,
    this.role, {
    Key? key,
    this.icon = const Icon(Icons.arrow_forward_ios_outlined),
  }) : super(key: key);

  final String uid;
  final String fullName;
  final String homeroom;
  final String gradeLevel;
  final String phoneNumber;
  final String emailAddress;
  final int role;

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showAvatar(uid, 35),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$fullName ($gradeLevel)",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "@ $homeroom",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      emailAddress,
                      style: Theme.of(context).textTheme.bodySmall,
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
                      phoneNumber,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ],
            ),
          ),
          icon
        ],
      ),
    );
  }
}
