import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/helpers/pair.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/services/firebase_service.dart';
import 'package:whapp/widgets/information_block.dart';
import 'package:whapp/widgets/pmc_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
    this.profileOwner, {
    Key? key,
  }) : super(key: key);

  final Member profileOwner;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var currentMember = Provider.of<Member?>(context);
    var profileOwner = widget.profileOwner;

    if (currentMember == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var isBoard = currentMember.role <= 2;
    var isAdmin = currentMember.role == 1;

    var same = currentMember.uid == profileOwner.uid;
    var profileName = profileOwner.fullName.split(" ");

    var firstName = profileName.first;
    var initials = initial(profileOwner.fullName);

    var tShirtReceived = profileOwner.tShirtReceived!;
    var duesPaid = profileOwner.duesPaid!;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          same
              ? SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  title: const Text("My Profile"),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                )
              : SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  title: Text("$firstName's Profile"),
                  actions: [
                    if (isAdmin)
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          if (profileOwner.role < 3)
                            PopupMenuItem(
                              child: Text(
                                "Demote to general",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              onTap: () => FirebaseService.instance.updateMemberFields(profileOwner.uid, {"role": 3}),
                            ),
                          if (profileOwner.role != 2)
                            PopupMenuItem(
                              child: Text(
                                "Promote to board",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              onTap: () => FirebaseService.instance.updateMemberFields(profileOwner.uid, {"role": 2}),
                            ),
                          if (profileOwner.role != 1)
                            PopupMenuItem(
                              child: Text(
                                "Promote to admin",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              onTap: () => FirebaseService.instance.updateMemberFields(profileOwner.uid, {"role": 1}),
                            ),
                        ],
                      ),
                  ],
                ),
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 75,
                  child: Text(
                    initials,
                    style: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  profileOwner.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Center(
                child: Text(
                  getRoleName(profileOwner.role),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 30,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: (tShirtReceived ? 1 : 0) + (duesPaid ? 1 : 0),
                    itemBuilder: (context, index) => [
                      if (tShirtReceived) tShirtReceivedChip,
                      if (duesPaid) paidDuesChip,
                    ][index],
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: hPad,
                child: PMC(profileOwner.points, profileOwner.minutes, profileOwner.collection),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: hPad,
                child: InformationBlock(title: "Contact Information", entries: [
                  Pair("Email address", profileOwner.emailAddress),
                  Pair("Street address", profileOwner.streetAddress),
                  Pair("Phone number", profileOwner.phoneNumber),
                ]),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: hPad,
                child: InformationBlock(
                  title: "Student Information",
                  entries: [
                    Pair("Student ID", profileOwner.studentId),
                    Pair("Homeroom", profileOwner.homeroom),
                    Pair("Grade level", profileOwner.gradeLevel.toString()),
                    Pair("T-Shirt size", profileOwner.tShirtSize.toUpperCase()),
                  ],
                ),
              ),
              if (isAdmin || !same && isBoard) ...[
                const SizedBox(height: 30),
                Padding(
                  padding: hPad,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: primaryColor,
                    ),
                    onPressed: () => FirebaseService.instance.updateMemberFields(
                      profileOwner.uid,
                      {"tShirtReceived": !tShirtReceived},
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check),
                        SizedBox(width: 10),
                        Text("T-Shirt Received"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: hPad,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: primaryColor,
                    ),
                    onPressed: () => FirebaseService.instance.updateMemberFields(
                      profileOwner.uid,
                      {"duesPaid": !duesPaid},
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.attach_money_outlined),
                        SizedBox(width: 10),
                        Text("Payment Submitted"),
                      ],
                    ),
                  ),
                ),
              ],
              if (same) ...[
                const SizedBox(height: 30),
                Padding(
                  padding: hPad,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: const Color(0xFFBD4747),
                    ),
                    onPressed: () => FirebaseService.instance.logout(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout_outlined),
                        SizedBox(width: 10),
                        Text("Log out"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
              const SizedBox(height: 50),
            ]),
          )
        ],
      ),
    );
  }
}
