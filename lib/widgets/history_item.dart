import 'package:flutter/material.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/history.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem(this.history, {Key? key}) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    if (history.eid != null) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: palette[7].withAlpha(20),
              offset: Offset(0, 15),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.eventTitle!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (history.message != null)
                    Text(
                      history.message!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (history.pointsEarned != 0)
                    Text(
                      "+ ${history.pointsEarned} points",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (history.minutesEarned != 0)
                    Text(
                      "+ ${history.minutesEarned} minutes",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (history.collectionEarned != 0)
                    Text(
                      "+ \$${history.collectionEarned}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: palette[7].withAlpha(20),
              offset: Offset(0, 15),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.message!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (history.pointsEarned != 0)
                    Text(
                      "+ ${history.pointsEarned} points",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (history.minutesEarned != 0)
                    Text(
                      "+ ${history.minutesEarned} minutes",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (history.collectionEarned != 0)
                    Text(
                      "+ \$${history.collectionEarned}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
