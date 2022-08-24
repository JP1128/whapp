import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/algolia_service.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/services/firebase_service.dart';
import 'package:whapp/widgets/member_item.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage(this.event, {Key? key}) : super(key: key);

  final Event event;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _algolia = AlgoliaService.algolia;
  var _results = <AlgoliaObjectSnapshot>[];

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentMember = Provider.of<Member?>(context);

    if (currentMember == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var event = widget.event;

    var isBoard = currentMember.role <= 2;
    var isVolunteer = event.eventType == EventType.volunteer;
    var isAttendance = event.eventType == EventType.attendance;

    var isSignedUp = isVolunteer ? event.signUpsId!.contains(currentMember.uid) : false;
    var isFull = isVolunteer ? event.signUpsId!.length >= event.capacity! : false;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            actions: [
              if (isBoard)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(
                        "Edit",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        "Delete",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      onTap: () {
                        FirebaseService.instance.deleteEvent(event.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const SizedBox(height: 30),
                if (widget.event.boardOnly)
                  Text(
                    "Board member only",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: palette[6],
                        ),
                  ),
                Padding(
                  padding: hPad,
                  child: Text(
                    widget.event.title,
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
                        formatDate(widget.event.start, "MMMM d, EEEE"),
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
                        "${formatDate(widget.event.start, 'jm')} - ${formatDate(widget.event.end, 'jm')} (${widget.event.end.difference(widget.event.start).inMinutes} minutes)",
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
                        widget.event.location,
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
                    widget.event.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Divider(
                  height: 100,
                  indent: 50,
                  endIndent: 50,
                ),
                if (isVolunteer) ...[
                  Padding(
                    padding: hPad,
                    child: Text(
                      "SignUp List",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
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
                  return Padding(
                    padding: hPad,
                    child: Text(
                      member.fullName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: defaultPadding,
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
                child: Icon(Icons.attach_money_outlined),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: "members",
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
                child: Icon(Icons.group_outlined),
              ),
              const SizedBox(width: 10),
            ],
            if (isVolunteer && !isSignedUp && (isBoard || !isFull))
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    FirebaseService.instance.signUpToVolunteerEvent(currentMember, widget.event.id);
                  },
                  child: Text("Sign Up"),
                ),
              ),
            if (isVolunteer && isSignedUp)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    FirebaseService.instance.cancelVolunteerEvent(currentMember, widget.event.id);
                  },
                  child: Text("Cancel"),
                ),
              ),
            if (isAttendance && isBoard)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
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
                  child: Text("Check In"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
