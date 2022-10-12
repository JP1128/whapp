import 'dart:developer';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/widgets/member_item.dart';

import '../../helpers/algolia_service.dart';
import '../../helpers/helper.dart';
import '../../models/event.dart';
import '../../services/firebase_service.dart';

class AttendanceCheckInPage extends StatefulWidget {
  const AttendanceCheckInPage({Key? key}) : super(key: key);

  @override
  State<AttendanceCheckInPage> createState() => _AttendanceCheckInPageState();
}

class _AttendanceCheckInPageState extends State<AttendanceCheckInPage> {
  final _algolia = AlgoliaService.algolia;
  var _results = <AlgoliaObjectSnapshot>[];

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var event = Provider.of<Event?>(context);

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Check In"),
          bottom: TabBar(
            labelColor: palette[7],
            tabs: [
              Tab(text: "Search"),
              Tab(text: "Checked"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
                  child: TextField(
                    controller: search,
                    style: Theme.of(context).textTheme.bodySmall,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search_rounded),
                      hintText: "Search members by name",
                    ),
                    onChanged: (value) async {
                      if (value.isNotEmpty) {
                        var query = _algolia.instance //
                            .index('memberIndex')
                            .query(value);

                        await query //
                            .getObjects()
                            .then((value) => setState(() => _results = value.hits));
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      var data = _results[index].data;

                      bool checkedIn = event!.signUpsId!.contains(data['objectID']);

                      return Padding(
                        padding: hPad,
                        child: InkWell(
                          child: MemberItem(
                            data['objectID'],
                            data['fullName'],
                            data['homeroom'],
                            data['gradeLevel'],
                            data['phoneNumber'],
                            data['emailAddress'],
                            data['role'],
                            icon: checkedIn
                                ? const Icon(
                                    Icons.check_circle,
                                    color: successColor,
                                  )
                                : Icon(
                                    Icons.check_circle_outline,
                                    color: palette[6],
                                  ),
                          ),
                          onTap: () {
                            var signedUpMember = SignedUpMembers(
                              uid: data['objectID'],
                              fullName: data['fullName'],
                              gradeLevel: data['gradeLevel'],
                              phoneNumber: data['phoneNumber'],
                              emailAddress: data['emailAddress'],
                              raised: 0,
                            );

                            setState(() {
                              if (!checkedIn) {
                                FirebaseService.instance.signUpToEvent(signedUpMember, event.id);
                              } else {
                                FirebaseService.instance.cancelVolunteerEvent(signedUpMember, event.id);
                              }

                              checkedIn = event.signUpsId!.contains(data['objectID']);
                              log(event.signUpsId!.toString());
                              log(checkedIn.toString());
                            });
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                )
              ],
            ),
            Builder(builder: (context) {
              return Padding(
                padding: hPad.copyWith(top: 30),
                child: ListView.separated(
                  itemCount: event!.signUpsId!.length,
                  itemBuilder: ((context, index) {
                    var member = event.signUps![index];
                    return Row(
                      children: [
                        showAvatar(member.uid, 30),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  member.fullName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            Text(
                              member.gradeLevel,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 30);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
