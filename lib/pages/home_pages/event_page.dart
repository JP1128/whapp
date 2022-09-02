import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/pages/event_pages/event_creation_page.dart';
import 'package:whapp/pages/event_pages/event_detail_page.dart';
import 'package:whapp/services/firebase_service.dart';
import 'package:whapp/widgets/event_item.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    var currentMember = Provider.of<Member?>(context);

    var isBoard = currentMember!.role <= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          onPressed: () {
            showWIP(context);
          },
          icon: const Icon(
            Icons.notifications_outlined,
          ),
        ),
        actions: [
          if (isBoard)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) {
                      return const EventCreationPage();
                    }),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Builder(builder: (context) {
        var events = Provider.of<List<Event>?>(context);

        if (events == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (events.isEmpty) {
          return const Center(child: Text("No upcoming events :'("));
        }

        var eventListing = events.toList();
        eventListing.sort((e1, e2) => e1.start.isAfter(e2.start) ? 1 : 0);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: eventListing.length,
                (context, index) {
                  var data = eventListing[index];
                  return Column(
                    children: [
                      Padding(
                        padding: hPad,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(builder: (context) {
                                return StreamProvider.value(
                                  value: FirebaseService.instance.memberChanges(),
                                  initialData: null,
                                  lazy: true,
                                  child: StreamProvider.value(
                                    value: FirebaseService.instance.streamEvent(data.id),
                                    initialData: data,
                                    child: const EventDetailPage(),
                                  ),
                                );
                              }),
                            );
                          },
                          child: EventItem(data),
                        ),
                      ),
                      if (index < eventListing.length) const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
