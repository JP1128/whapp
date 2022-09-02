import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/history.dart';
import 'package:whapp/widgets/history_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            onPressed: () {
              showWIP(context);
            },
            icon: Icon(Icons.filter_list_outlined),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        var histories = Provider.of<List<History>?>(context);

        if (histories == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (histories.isEmpty) {
          return const Center(child: Text("No activities"));
        }

        var historiesSorted = histories.toList();
        historiesSorted.sort((a, b) => a.timestamp.millisecondsSinceEpoch - b.timestamp.millisecondsSinceEpoch);

        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: historiesSorted.length,
                (context, index) {
                  var history = historiesSorted[index];
                  return Column(
                    children: [
                      Padding(
                        padding: hPad,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Column(
                                children: [
                                  Text(
                                    formatDate(history.timestamp.toDate(), "Md"),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    formatDate(history.timestamp.toDate(), "E"),
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: HistoryItem(history)),
                          ],
                        ),
                      ),
                      if (index < histories.length) const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
