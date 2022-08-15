import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/pair.dart';

class InformationBlock extends StatelessWidget {
  InformationBlock({
    Key? key,
    required this.title,
    required this.entries,
  }) : super(key: key);

  final String title;
  final List<Pair<String, String?>> entries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: Get.textTheme.titleSmall),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: palette[6].withAlpha(0x22),
                  offset: const Offset(0, 10),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Column(
              children: entries.map<Widget>((entry) {
                var fieldName = entry.left;
                var fieldValue = entry.right;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fieldName, style: Get.textTheme.titleSmall),
                      Text(
                        fieldValue ?? '-',
                        textAlign: TextAlign.right,
                        style: Get.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
