import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/algolia_service.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/member.dart';
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

  @override
  Widget build(BuildContext context) {
    var currentMember = Provider.of<Member?>(context);
    var event = Provider.of<Event?>(context);

    if (currentMember == null || event == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  Text(
                    "Board member only",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: palette[6],
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
                                              child: getAvatar(member.uid, 100)),
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
                                  ),
                                );
                              });
                        }
                      },
                      child: Row(
                        children: [
                          getAvatar(member.uid, 50),
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
                                  ]
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
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            if (isBoard && isVolunteer) ...[
              FloatingActionButton(
                heroTag: "money",
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: event.signUps!.length,
                              (context, index) {
                                var member = event.signUps![index];
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
                    FirebaseService.instance.signUpToVolunteerEvent(currentMember, event.id);
                  },
                  label: const Text("Sign Up"),
                ),
              ),
            if (isVolunteer && isSignedUp)
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
                            print(isLateNotice);

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
                                    FirebaseService.instance.cancelVolunteerEvent(currentMember, event.id);
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
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CustomScrollView(
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

                                      await query
                                          .getObjects() //
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
                                        icon: Icons.check,
                                      ),
                                      onTap: () {},
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
