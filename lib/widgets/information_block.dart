import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/pair.dart';

class InformationBlock extends StatelessWidget {
  const InformationBlock({
    Key? key,
    required this.title,
    required this.entries,
  }) : super(key: key);

  final String title;
  final List<Pair<String, String?>> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries
                      .map<Widget>((entry) {
                        var fieldName = entry.left;
                        var fieldValue = entry.right;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fieldName,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: palette[6],
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                fieldValue ?? '-',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        );
                      })
                      .intersperse(Divider())
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
