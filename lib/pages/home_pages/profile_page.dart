import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/helpers/pair.dart';
import 'package:whapp/widgets/information_block.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, Colors.transparent, Colors.transparent, primaryColor],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(rect),
          blendMode: BlendMode.dstOut,
          child: SingleChildScrollView(
            child: Container(
              padding: defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: CircleAvatar(
                      // foregroundImage: NetworkImage(member.photoURL ?? "http://www.gravatar.com/avatar"),
                      backgroundColor: primaryColor,
                      radius: 75,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text(
                  //   member.fullName,
                  //   style: Get.textTheme.titleLarge,
                  // ),
                  // Text(
                  //   "${getRoleName(member.role).capitalize}",
                  //   style: Get.textTheme.titleSmall,
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     SizedBox(
                  //       width: 100,
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             member.points == 0 ? "-" : member.points.toString(),
                  //             style: Get.textTheme.titleMedium,
                  //           ),
                  //           Text(
                  //             "Points",
                  //             style: Get.textTheme.titleSmall,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 100,
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             member.minutes == 0 ? "-" : member.minutes.toString(),
                  //             style: Get.textTheme.titleMedium,
                  //           ),
                  //           Text(
                  //             "Minutes",
                  //             style: Get.textTheme.titleSmall,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 100,
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             member.collection == 0 ? "-" : "\$${member.collection.toString()}",
                  //             style: Get.textTheme.titleMedium,
                  //           ),
                  //           Text(
                  //             "Collection",
                  //             style: Get.textTheme.titleSmall,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 30),
                  InformationBlock(
                    title: "Contact Information",
                    entries: [
                      Pair("Email address", _ac.member.value!.emailAddress),
                      Pair("Cell phone", parsePhoneNumber(_ac.member.value!.phoneNumber)),
                      Pair("Address", _ac.member.value!.streetAddress),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InformationBlock(
                    title: "Student Information",
                    entries: [
                      Pair("Student ID", _ac.member.value!.studentId),
                      Pair("Full name", _ac.member.value!.fullName),
                      Pair("Homeroom", _ac.member.value!.homeroom),
                      Pair("Grade level", _ac.member.value!.gradeLevel.toString()),
                      Pair("T-Shirt size", _ac.member.value!.tShirtSize.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 50),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: const Color(0xFFBD4747),
                    ),
                    onPressed: () => _ac.logout(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout_outlined),
                        SizedBox(width: 10),
                        Text("Log out"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
