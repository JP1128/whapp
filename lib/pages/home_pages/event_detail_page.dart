import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/models/events/event.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final AuthController _ac = Get.find();
  late Event _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            actions: [
              if (_ac.member.value != null && _ac.member.value!.role < 3)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: defaultPadding,
              child: Column(
                children: [
                  if (_event.boardOnly)
                    Text(
                      "Board member only",
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: palette[6],
                      ),
                    ),
                  Text(
                    _event.title,
                    style: Get.textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
