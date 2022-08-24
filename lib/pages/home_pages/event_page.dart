import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
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
    var events = Provider.of<List<Event>?>(context);

    if (events == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var modifiable = events.toList();
    modifiable.sort((e1, e2) => e1.start.isBefore(e2.start) ? 0 : 1);

    var isBoard = currentMember!.role <= 2;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text("Home"),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_outline),
          ),
          actions: [
            if (isBoard)
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) {
                        return EventCreationPage();
                      }),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: modifiable.length,
            (context, index) {
              var data = modifiable[index];
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
                              child: EventDetailPage(data),
                            );
                          }),
                        );
                      },
                      child: EventItem(data),
                    ),
                  ),
                  if (index < modifiable.length) const SizedBox(height: 10),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
