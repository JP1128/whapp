import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/algolia_service.dart';
import 'package:whapp/pages/new_profile_page.dart';
import 'package:whapp/widgets/member_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Algolia algolia = AlgoliaService.algolia;

  Rx<List<AlgoliaObjectSnapshot>> _results = Rx<List<AlgoliaObjectSnapshot>>([]);

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
        child: Column(
          children: [
            TextField(
              controller: search,
              style: Get.textTheme.bodySmall,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search_rounded),
                hintText: "Search members",
              ),
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  var query = algolia.instance //
                      .index('memberIndex')
                      .query(value);

                  _results.value = (await query.getObjects()).hits;
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (_results.value.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(50),
                    child: Center(
                      child: Text(
                        "Could not find anyone with that name :(",
                        textAlign: TextAlign.center,
                        style: Get.textTheme.titleMedium!.copyWith(color: palette[5]),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _results.value.length,
                    itemBuilder: (context, index) {
                      var snap = _results.value[index];
                      var data = snap.data;
                      return GestureDetector(
                        child: MemberItem(
                          fullName: data['fullName'],
                          homeroom: data['homeroom'],
                          gradeLevel: data['gradeLevel'],
                          phoneNumber: data['phoneNumber'],
                          emailAddress: data['emailAddress'],
                        ),
                        onTap: () => Get.to(() => NewProfilePage(uid: data['objectID'])),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
