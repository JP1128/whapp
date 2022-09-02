import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  final _fk = GlobalKey<FormBuilderState>();

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
                      onPressed: () {
                        showWIP(context);
                        getAvatarString(profileOwner.uid) //
                            .then(
                          (value) => FirebaseService.instance.updateMemberFields(
                            profileOwner.uid,
                            {
                              'photoURL': value,
                            },
                          ),
                        );
                      },
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
                // child: CircleAvatar(
                //   backgroundColor: primaryColor,
                //   radius: 75,
                //   child: Text(
                //     initials,
                //     style: Theme.of(context).primaryTextTheme.displayMedium,
                //   ),
                // ),
                // child: getAvatar(profileOwner.uid, 150),
                child: SvgPicture.string(
                  profileOwner.photoURL!,
                  width: 150,
                  height: 150,
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
                    onPressed: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: defaultPadding,
                                  child: FormBuilder(
                                    key: _fk,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Manual entry",
                                          style: Theme.of(context).textTheme.displayLarge,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Specify how much points, minutes, and/or collection the member will be rewarded, and describe the reason.",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 50),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: FormBuilderTextField(
                                                name: "pointsEarned",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                                  label: Text("Points"),
                                                ),
                                                textAlign: TextAlign.center,
                                                validator: FormBuilderValidators.compose(
                                                  [
                                                    FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: FormBuilderTextField(
                                                name: "minutesEarned",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                                  label: Text("Minutes"),
                                                ),
                                                textAlign: TextAlign.center,
                                                validator: FormBuilderValidators.compose(
                                                  [
                                                    FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: FormBuilderTextField(
                                                name: "collectionEarned",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                                  label: Text("Collection"),
                                                  prefixText: '\$ ',
                                                ),
                                                textAlign: TextAlign.center,
                                                validator: FormBuilderValidators.compose(
                                                  [
                                                    FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        FormBuilderTextField(
                                          name: "message",
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          textCapitalization: TextCapitalization.sentences,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          textInputAction: TextInputAction.newline,
                                          keyboardType: TextInputType.multiline,
                                          decoration: const InputDecoration(
                                            label: Text("Reason for the entry"),
                                          ),
                                          textAlignVertical: TextAlignVertical.top,
                                          maxLines: 6,
                                          maxLength: 256,
                                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                          validator: FormBuilderValidators.compose(
                                            [
                                              FormBuilderValidators.required(errorText: "Enter the reason"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        ElevatedButton(
                                          onPressed: () {
                                            var cs = _fk.currentState;
                                            if (cs != null && cs.saveAndValidate()) {
                                              final values = cs.value;

                                              final p = int.tryParse(values['pointsEarned'] ?? "") ?? 0;
                                              final m = int.tryParse(values['minutesEarned'] ?? "") ?? 0;
                                              final c = double.tryParse(values['collectionEarned'] ?? "") ?? 0;
                                              FirebaseService.instance.updateMemberPMC(
                                                profileOwner.uid,
                                                points: p,
                                                minutes: m,
                                                collection: c,
                                              );

                                              final message = values['message'];
                                              FirebaseService.instance.createHistory(
                                                profileOwner.uid,
                                                message: message,
                                                pointsEarned: p,
                                                minutesEarned: m,
                                                collectionEarned: c,
                                              );

                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Submit"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Manual Entry"),
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!tShirtReceived)
                                    Text(
                                      "Continue with marking this member as having received the T-Shirt?",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (tShirtReceived)
                                    Text(
                                      "Continue with unmarking this member?",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseService.instance.updateMemberFields(
                                      profileOwner.uid,
                                      {"tShirtReceived": !tShirtReceived},
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!duesPaid)
                                    Text(
                                      "Continue with marking this member as having paid the dues?",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (duesPaid)
                                    Text(
                                      "Continue with unmarking this member?",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseService.instance.updateMemberFields(
                                      profileOwner.uid,
                                      {"duesPaid": !duesPaid},
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          });
                    },
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
