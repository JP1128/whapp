import 'package:flutter/material.dart';
import 'package:whapp/constants/theme.dart';

class PMC extends StatelessWidget {
  const PMC(
    this.points,
    this.minutes,
    this.collection, {
    Key? key,
  }) : super(key: key);

  final int points;
  final int minutes;
  final double collection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: ShapeDecoration(
        color: palette.first,
        shadows: [
          BoxShadow(
            color: primaryColor.withAlpha(30),
            offset: const Offset(0, 15),
            blurRadius: 30,
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  points == 0 ? "-" : points.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Points",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minutes == 0 ? "-" : minutes.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Minutes",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  collection == 0 ? "-" : collection.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Collection",
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
