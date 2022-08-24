import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/helpers/algolia_service.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/pages/home_pages/profile_page.dart';
import 'package:whapp/services/firebase_service.dart';
import 'package:whapp/widgets/member_item.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({Key? key}) : super(key: key);

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final _algolia = AlgoliaService.algolia;
  var _results = <AlgoliaObjectSnapshot>[];

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverAppBar(
          title: Text("Directory"),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: hPad.copyWith(bottom: 20),
            child: TextField(
              controller: search,
              style: Theme.of(context).textTheme.bodySmall,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search_rounded),
                hintText: "Search members by name",
              ),
              onChanged: (value) async {
                var query = _algolia.instance //
                    .index('memberIndex')
                    .query(value.isEmpty ? "*" : value);

                await query
                    .getObjects() //
                    .then((value) => setState(() => _results = value.hits));
              },
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: _results.length,
            (context, index) {
              var data = _results[index].data;
              return Padding(
                padding: hPad,
                child: InkWell(
                  child: MemberItem(
                    data['fullName'],
                    data['homeroom'],
                    data['gradeLevel'],
                    data['phoneNumber'],
                    data['emailAddress'],
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) {
                        return StreamBuilder<Member?>(
                          stream: FirebaseService.instance.memberChangesById(data['objectID']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return StreamProvider.value(
                                value: FirebaseService.instance.memberChanges(),
                                initialData: null,
                                lazy: true,
                                child: ProfilePage(snapshot.data!),
                              );
                            }

                            return const Center(child: CircularProgressIndicator());
                          },
                        );
                      }),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
