import 'package:whapp/models/events/event.dart';

class ItemDonationEvent extends Event {
  ItemDonationEvent({
    required super.id,
    required super.boardOnly,
    required super.title,
    required super.description,
    required super.location,
    required super.start,
    required super.end,
  });
}
