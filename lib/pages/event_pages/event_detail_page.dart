import 'dart:developer';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/algolia_service.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/pages/event_pages/attendance_check_in_page.dart';
import 'package:whapp/pages/home_pages/profile_page.dart';
import 'package:whapp/services/firebase_service.dart';
import 'package:whapp/widgets/member_item.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({Key? key}) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _fk = GlobalKey<FormBuilderState>();

  final _algolia = AlgoliaService.algolia;
  var _results = <AlgoliaObjectSnapshot>[];

  final search = TextEditingController();

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  double? raised;

  @override
  Widget build(BuildContext context) {
    var currentMember = Provider.of<Member?>(context);
    var event = Provider.of<Event?>(context);

    if (currentMember == null || event == null) {
      return const Center(child: CircularProgressIndicator());
    }

    log(event.title);

    var isBoard = currentMember.role <= 2;
    var isVolunteer = event.eventType == EventType.volunteer;
    var isAttendance = event.eventType == EventType.attendance;

    var isSignedUp = isVolunteer ? event.signUpsId!.contains(currentMember.uid) : false;
    var isFull = isVolunteer ? event.signUpsId!.length >= event.capacity! : false;

    var isChecked = isVolunteer ? event.checkedId!.contains(currentMember.uid) : false;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            actions: [
              if (isBoard) ...[
                IconButton(
                  onPressed: () {
                    showWIP(context);
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () {
                    FirebaseService.instance.deleteEvent(event.id);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outlined),
                ),
              ],
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const SizedBox(height: 30),
                if (event.boardOnly)
                  Padding(
                    padding: hPad,
                    child: Text(
                      "Board member only",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: palette[6],
                          ),
                    ),
                  ),
                Padding(
                  padding: hPad,
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: hPad,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: palette[6],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatDate(event.start, "MMMM d, EEEE"),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: palette[6],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: hPad,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: palette[6],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${formatDate(event.start, 'jm')} - ${formatDate(event.end, 'jm')} (${event.end.difference(event.start).inMinutes} minutes)",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: palette[6],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: hPad,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: palette[6],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        event.location,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: palette[6],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: hPad,
                  child: Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: hPad,
                  child: Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const Divider(
                  height: 100,
                  indent: 50,
                  endIndent: 50,
                ),
                if (isVolunteer) ...[
                  Padding(
                    padding: hPad,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sign Ups (${event.signUps!.length}/${event.capacity})",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
                        ),
                        if (isBoard)
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_outlined),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (event.signUps!.isEmpty)
                    Padding(
                      padding: hPad,
                      child: Text(
                        "No one has signed up yet :(",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ]
              ],
            ),
          ),
          if (isVolunteer && event.signUps!.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: event.signUps!.length,
                (context, index) {
                  var member = event.signUps![index];
                  var checked = event.checkedId!.contains(member.uid);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: InkWell(
                      onTap: () {
                        if (isBoard && !checked) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                startTime = TimeOfDay.fromDateTime(event.start);
                                endTime = TimeOfDay.fromDateTime(event.end);

                                return StatefulBuilder(
                                  builder: (context, setState) => Dialog(
                                    insetPadding: const EdgeInsets.all(20.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 30,
                                        left: 30,
                                        right: 30,
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.of(context, rootNavigator: true).push(
                                                  MaterialPageRoute(builder: (context) {
                                                    return StreamBuilder<Member?>(
                                                      stream: FirebaseService.instance.memberChangesById(member.uid),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return StreamProvider.value(
                                                            value: FirebaseService.instance.memberChanges(),
                                                            initialData: null,
                                                            lazy: true,
                                                            child: ProfilePage(snapshot.data!),
                                                          );
                                                        }

                                                        return const Center(child: CircularProgressIndicator());
                                                      },
                                                    );
                                                  }),
                                                );
                                              },
                                              child: showAvatar(member.uid, 75)),
                                          const SizedBox(height: 20),
                                          Text(
                                            member.fullName,
                                            style: Theme.of(context).textTheme.titleLarge,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(member.emailAddress),
                                          const SizedBox(height: 5),
                                          Text(member.phoneNumber),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    const Text("In"),
                                                    const SizedBox(height: 10),
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        showTimePicker(
                                                          context: context,
                                                          initialTime: startTime!,
                                                        ).then((value) {
                                                          if (value != null) {
                                                            setState(() {
                                                              startTime = value;
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Text(startTime!.format(context)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    const Text("Out"),
                                                    const SizedBox(height: 10),
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        showTimePicker(
                                                          context: context,
                                                          initialTime: endTime!,
                                                        ).then((value) {
                                                          if (value != null) {
                                                            setState(() {
                                                              endTime = value;
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Text(endTime!.format(context)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // TextButton(
                                              //   onPressed: () {},
                                              //   icon: Icon(
                                              //     Icons.delete_outline,
                                              //   ),
                                              //   color: errorColor,
                                              // ),
                                              // const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        if (startTime!.hour >= endTime!.hour && startTime!.minute >= endTime!.minute) {
                                                          showError(context, "Start time cannot be later than the end time.");
                                                          return;
                                                        }

                                                        var minutes = minuteFromTimeOfDay(startTime!, endTime!);
                                                        var points = minutes ~/ 10;

                                                        FirebaseService.instance.checkOutVolunteer(member.uid, event.id);
                                                        FirebaseService.instance.updateMemberPMC(
                                                          member.uid,
                                                          points: points,
                                                          minutes: minutes,
                                                        );
                                                        FirebaseService.instance.createHistory(
                                                          member.uid,
                                                          event: event,
                                                          in_: startTime,
                                                          out: endTime,
                                                          message: "Participated in the event.",
                                                          pointsEarned: points,
                                                          minutesEarned: minutes,
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Check Out"),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text("${minuteFromTimeOfDay(startTime!, endTime!)} minutes"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          TextButton(
                                            onPressed: () {
                                              FirebaseService.instance.cancelVolunteerEvent(member, event.id);
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(primary: errorColor),
                                            child: const Text(
                                              "Remove",
                                              style: TextStyle(decoration: TextDecoration.underline),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }

                        if (isBoard && checked) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) => Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context, rootNavigator: true).push(
                                                MaterialPageRoute(builder: (context) {
                                                  return StreamBuilder<Member?>(
                                                    stream: FirebaseService.instance.memberChangesById(member.uid),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return StreamProvider.value(
                                                          value: FirebaseService.instance.memberChanges(),
                                                          initialData: null,
                                                          lazy: true,
                                                          child: ProfilePage(snapshot.data!),
                                                        );
                                                      }

                                                      return const Center(child: CircularProgressIndicator());
                                                    },
                                                  );
                                                }),
                                              );
                                            },
                                            child: showAvatar(member.uid, 100),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            member.fullName,
                                            style: Theme.of(context).textTheme.titleLarge,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(member.emailAddress),
                                          const SizedBox(height: 5),
                                          Text(member.phoneNumber),
                                          const SizedBox(height: 20),
                                          FormBuilder(
                                            key: _fk,
                                            child: FormBuilderTextField(
                                              name: "collection",
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                label: Text("Personal collection"),
                                                prefixText: "\$ ",
                                              ),
                                              validator: FormBuilderValidators.compose(
                                                [
                                                  FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                                  FormBuilderValidators.min(0, errorText: "The number must be at least 0")
                                                ],
                                              ),
                                              onSaved: (val) {
                                                var doubleVal = double.parse(val!);
                                                raised = ((doubleVal * 100).roundToDouble() / 100);
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_fk.currentState!.saveAndValidate()) {
                                                FirebaseService.instance.updateMemberPMC(
                                                  member.uid,
                                                  collection: raised!,
                                                );
                                                FirebaseService.instance.createHistory(
                                                  member.uid,
                                                  collectionEarned: raised!,
                                                  message: "Raised \$$raised at ${event.title}",
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Report Personal Collection"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      child: Row(
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
                                  if (checked) ...[
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: successColor,
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                member.gradeLevel,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            if (isBoard && isVolunteer) ...[
              FloatingActionButton(
                heroTag: "money",
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) {
                      var checked = event.signUps!.where((e) => event.checkedId!.contains(e.uid)).toList();

                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: checked.length,
                              (context, index) {
                                var member = checked[index];
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.attach_money_outlined),
              ),
              const SizedBox(width: 10),
            ],
            if (isVolunteer && !isSignedUp && (isBoard || !isFull))
              Expanded(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    var signedUpMember = SignedUpMembers(
                      uid: currentMember.uid,
                      fullName: currentMember.fullName,
                      gradeLevel: currentMember.gradeLevel,
                      phoneNumber: currentMember.phoneNumber,
                      emailAddress: currentMember.emailAddress,
                      raised: 0,
                    );
                    FirebaseService.instance.signUpToEvent(signedUpMember, event.id);
                  },
                  label: const Text("Sign Up"),
                ),
              ),
            if (isVolunteer && !isSignedUp && (!isBoard && isFull))
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "This event is full. Request a permission from a board member to join this event.",
                        style: TextStyle(color: errorColor),
                      ),
                    ),
                  ],
                ),
              ),
            if (isVolunteer && isSignedUp && !isChecked)
              Expanded(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (isChecked) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                  "You cannot cancel once you are checked out.",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Ok"),
                                  ),
                                ],
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            var now = DateTime.now();
                            var diff = event.start.difference(now);
                            var isLateNotice = diff.inHours < 24;

                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Are you sure you want to remove yourself from the sign up?",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "If you cancel within 24 hours before the event starts, you may lose 20 points.",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: errorColor),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    for (var signedUpMember in event.signUps!) {
                                      if (signedUpMember.uid == currentMember.uid) {
                                        FirebaseService.instance.cancelVolunteerEvent(signedUpMember, event.id);
                                        break;
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  label: const Text("Cancel"),
                  backgroundColor: Colors.transparent,
                  foregroundColor: errorColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: errorColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            if (isAttendance && isBoard)
              Expanded(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) {
                      return StreamProvider.value(
                        value: FirebaseService.instance.streamEvent(event.id),
                        initialData: event,
                        child: AttendanceCheckInPage(),
                      );
                    }));
                    /*
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Provider.value(
                          value: event,
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
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
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: _results.length,
                                  (context, index) {
                                    var data = _results[index].data;

                                    bool checkedIn = event.signUpsId!.contains(data['objectID']);

                                    return StatefulBuilder(builder: (context, setState) {
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
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    */
                  },
                  label: const Text("Check In"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
