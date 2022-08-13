import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/auth_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/helpers/pair.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/widgets/information_block.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = AuthController.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: const BackButton(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: FutureBuilder<Member?>(
        future: authController.getMember,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var member = snapshot.data!;

            return ShaderMask(
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
                      Center(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(member.photoURL),
                          radius: 75,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        member.fullName,
                        style: Get.textTheme.titleLarge,
                      ),
                      Text(
                        "${getRoleName(member.role).capitalize}",
                        style: Get.textTheme.titleSmall,
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
                                Text(
                                  member.points.toString(),
                                  style: Get.textTheme.titleMedium,
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
                                Text(
                                  member.minutes.toString(),
                                  style: Get.textTheme.titleMedium,
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
                                Text(
                                  "\$${member.collection.toString()}",
                                  style: Get.textTheme.titleMedium,
                                ),
                                Text(
                                  "Collection",
                                  style: Get.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      InformationBlock(
                        title: "Contact Information",
                        entries: [
                          Pair("Cell phone", member.cellPhone),
                          Pair("Address", member.address),
                        ],
                      ),
                      const SizedBox(height: 30),
                      InformationBlock(
                        title: "Student Information",
                        entries: [
                          Pair("Student ID", member.studentId),
                          Pair("Full name", member.fullName),
                          Pair("Homeroom", member.homeroom),
                          Pair("Grade level", member.gradeLevel.toString()),
                          Pair("Hispanic/Latino", boolToString(member.hispanic)),
                          Pair("Race", member.ethnicities?.join(", ")),
                          Pair("T-Shirt size", member.tShirtSize),
                        ],
                      ),
                      const SizedBox(height: 30),
                      InformationBlock(
                        title: "Primary Parent Information",
                        entries: [
                          Pair("Full name", member.primaryParent?.fullName),
                          Pair("Email", member.primaryParent?.emailAddress),
                          Pair("Cell phone", member.primaryParent?.cellPhone),
                          Pair("Work", member.primaryParent?.work),
                        ],
                      ),
                      const SizedBox(height: 50),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          primary: const Color(0xFFBD4747),
                        ),
                        onPressed: () => authController.logout(),
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
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
