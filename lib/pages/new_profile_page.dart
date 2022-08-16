import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/controllers/store_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/helpers/pair.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/widgets/information_block.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  final AuthController _ac = Get.find();
  final StoreController _sc = Get.find();

  late String uid;
  late Rx<Member?> member;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    member = Rx<Member?>(null);
    member.bindStream(_sc.streamMember(uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          if (_ac.isAdmin())
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(
                    "Promote to board member",
                    style: Get.textTheme.titleSmall,
                  ),
                  onTap: () {
                    _sc.updateMember(uid, {"role": 2});
                  },
                ),
              ],
            ),
        ],
      ),
      body: Obx(() {
        if (member.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Container(
            padding: defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 75,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Text(
                    member.value!.fullName,
                    style: Get.textTheme.titleLarge,
                  ),
                ),
                Obx(
                  () => Text(
                    "${getRoleName(member.value!.role).capitalize}",
                    style: Get.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              member.value!.points == 0 ? "-" : member.value!.points.toString(),
                              style: Get.textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            "Points",
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              member.value!.minutes == 0 ? "-" : member.value!.minutes.toString(),
                              style: Get.textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            "Minutes",
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                member.value!.collection == 0 ? "-" : "\$${member.value!.collection.toString()}",
                                style: Get.textTheme.titleMedium,
                              )),
                          Text(
                            "Collection",
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() => SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (member.value!.duesPaid!) paidDuesChip,
                          if (member.value!.tShirtReceived!) tShirtReceivedChip,
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Obx(() => InformationBlock(
                      title: "Contact Information",
                      entries: [
                        Pair("Email address", member.value!.emailAddress),
                        Pair("Cell phone", parsePhoneNumber(member.value!.phoneNumber)),
                        Pair("Address", member.value!.streetAddress),
                      ],
                    )),
                const SizedBox(height: 30),
                Obx(() => InformationBlock(
                      title: "Student Information",
                      entries: [
                        Pair("Student ID", member.value!.studentId),
                        Pair("Full name", member.value!.fullName),
                        Pair("Homeroom", member.value!.homeroom),
                        Pair("Grade level", member.value!.gradeLevel.toString()),
                        Pair("T-Shirt size", member.value!.tShirtSize.toUpperCase()),
                      ],
                    )),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(volunteerColor),
                        ),
                        onPressed: () => _sc.updateMember(uid, {"duesPaid": true}),
                        child: Text(
                          "Mark as paid dues",
                          style: poppins(15, semiBold, color: onVolunteerColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(volunteerColor),
                        ),
                        onPressed: () => _sc.updateMember(uid, {"tShirtReceived": true}),
                        child: Text(
                          "Mark as received t-Shirt",
                          style: poppins(15, semiBold, color: onVolunteerColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
