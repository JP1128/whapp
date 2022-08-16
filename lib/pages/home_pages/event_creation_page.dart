import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/controllers/events_controller.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/events/attendance.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/events/volunteer.dart';

class EventCreationPage extends StatefulWidget {
  EventCreationPage({Key? key}) : super(key: key);

  final fk = GlobalKey<FormBuilderState>();

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final EventsController _ec = Get.find();

  late GlobalKey<FormBuilderState> _fk;

  var startTime = Rx<TimeOfDay?>(null);
  var endTime = Rx<TimeOfDay?>(null);

  var index = 0.obs;

  @override
  void initState() {
    super.initState();
    _fk = widget.fk;
  }

  @override
  void dispose() {
    super.dispose();
    print("disposed");
    _ec.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: defaultPadding,
        child: FormBuilder(
          key: _fk,
          child: Obx(() => IndexedStack(
                index: index.value,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choose an event type", style: Get.textTheme.displayLarge),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          _ec.eventType = EventType.volunteer;
                          index.value += 1;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(palette.first),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: volunteerColor, width: 1.0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Volunteer",
                                    style: Get.textTheme.displayMedium!.copyWith(color: onVolunteerColor),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.volunteer_activism_rounded, color: onVolunteerColor),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Sign-ups are required to participate in the event.",
                                style: Get.textTheme.bodyMedium!.copyWith(color: onVolunteerColor),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Members receive minutes and points "
                                "based on how much of the event duration they participated.",
                                style: Get.textTheme.bodyMedium!.copyWith(color: onVolunteerColor),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Event sign-up may be restricted on the basis of points, minutes, and collections.",
                                style: Get.textTheme.bodyMedium!.copyWith(color: onVolunteerColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          _ec.eventType = EventType.attendance;
                          index.value += 1;
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(palette.first),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: attendanceColor, width: 1.0),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            )),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Attendance",
                                    style: Get.textTheme.displayMedium!.copyWith(color: onAttendanceColor),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.check_rounded, color: onAttendanceColor),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Members receive minutes and points based on attendance.",
                                style: Get.textTheme.bodyMedium!.copyWith(color: onAttendanceColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pick a date and time", style: Get.textTheme.displayLarge),
                      const SizedBox(height: 50),
                      SfDateRangePicker(
                        controller: _ec.dateController,
                        view: DateRangePickerView.month,
                        allowViewNavigation: false,
                        showNavigationArrow: true,
                        enablePastDates: false,
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(const Duration(days: 365)),
                        selectionMode: DateRangePickerSelectionMode.single,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text("Start time"),
                                const SizedBox(height: 10),
                                Obx(
                                  () => OutlinedButton(
                                    onPressed: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: startTime.value != null //
                                            ? startTime.value!
                                            : const TimeOfDay(hour: 12, minute: 0),
                                      ).then((value) {
                                        if (value != null) {
                                          startTime.value = value;
                                        }
                                      });
                                    },
                                    child: Text(startTime.value != null ? startTime.value!.format(context) : "-"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              children: [
                                const Text("End time"),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: startTime.value != null //
                                          ? TimeOfDay(
                                              hour: (startTime.value!.hour + 1) % 24,
                                              minute: (startTime.value!.minute),
                                            )
                                          : const TimeOfDay(hour: 13, minute: 0),
                                    ).then((value) {
                                      if (value != null) {
                                        endTime.value = value;
                                      }
                                    });
                                  },
                                  child: Text(endTime.value != null ? endTime.value!.format(context) : "-"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_ec.dateController.selectedDate == null) {
                            showError("Invalid setting", "Date is not chosen.");
                            return;
                          }

                          if (startTime.value == null || endTime.value == null) {
                            showError("Invalid setting", "Both start time and end time must be selected");
                            return;
                          }

                          if (startTime.value!.hour >= endTime.value!.hour && //
                              startTime.value!.minute >= endTime.value!.minute) {
                            showError("Invalid setting", "Start time cannot be later than end time");
                            return;
                          }

                          var date = _ec.dateController.selectedDate!;

                          _ec.start = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            startTime.value!.hour,
                            startTime.value!.minute,
                          );

                          _ec.end = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            endTime.value!.hour,
                            endTime.value!.minute,
                          );

                          index.value += 1;
                        },
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Fill out event details", style: Get.textTheme.displayLarge),
                      const SizedBox(height: 50),
                      FormBuilderTextField(
                        name: "title",
                        style: Get.textTheme.bodyMedium,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(label: Text("Title")),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(errorText: "Enter the event title"),
                          ],
                        ),
                        onSaved: (val) {
                          if (val != null) {
                            _ec.title = val;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: "location",
                        style: Get.textTheme.bodyMedium,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(label: Text("Location")),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(errorText: "Enter the location"),
                          ],
                        ),
                        onSaved: (val) {
                          if (val != null) {
                            _ec.location = val;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: "description",
                        style: Get.textTheme.bodyMedium,
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(label: Text("Description")),
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: 6,
                        maxLength: 256,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onSaved: (val) {
                          if (val != null) {
                            _ec.description = val;
                          }
                        },
                      ),
                      FormBuilderCheckbox(
                        name: "boardOnly",
                        title: Text("Board members only", style: Get.textTheme.bodyMedium),
                        activeColor: primaryColor,
                        onSaved: (val) {
                          if (val != null) {
                            _ec.boardOnly = val;
                          }
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_fk.currentState!.saveAndValidate()) {
                            index.value += 1;
                          }
                        },
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Additional information", style: Get.textTheme.displayLarge),
                      const SizedBox(height: 50),
                      if (_ec.eventType == EventType.volunteer)
                        Column(
                          children: [
                            FormBuilderTextField(
                              name: "capacity",
                              style: Get.textTheme.bodyMedium,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(label: Text("Capacity")),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                  FormBuilderValidators.min(1, errorText: "The number must be greater than 0"),
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  _ec.capacity = int.parse(val);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: "pointCost",
                              style: Get.textTheme.bodyMedium,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text("Point cost"),
                                prefixText: "- ",
                                suffixText: "points",
                              ),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                  FormBuilderValidators.min(0, errorText: "The number must be at least 0"),
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  _ec.pointCost = int.parse(val);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: "minMinutes",
                              style: Get.textTheme.bodyMedium,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text("Minutes requirement"),
                                suffixText: "minutes",
                              ),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                  FormBuilderValidators.min(0, errorText: "The number must be at least 0"),
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  _ec.minMinutes = int.parse(val);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: "minCollection",
                              style: Get.textTheme.bodyMedium,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text("Collection requirement"),
                                prefixText: "\$ ",
                              ),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                  FormBuilderValidators.min(0, errorText: "The number must be at least 0"),
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  _ec.minCollection = int.parse(val);
                                }
                              },
                            ),
                          ],
                        ),
                      if (_ec.eventType == EventType.attendance)
                        Column(
                          children: [
                            FormBuilderTextField(
                              name: "pointReward",
                              style: Get.textTheme.bodyMedium,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text("Points rewarded"),
                                suffixText: "points",
                              ),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                  FormBuilderValidators.min(0, errorText: "The number must be at least 0")
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  _ec.pointReward = int.parse(val);
                                }
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          if (_fk.currentState!.saveAndValidate()) {
                            switch (_ec.eventType) {
                              case EventType.volunteer:
                                _ec.createVolunteerEvent();
                                break;
                              case EventType.attendance:
                                _ec.createAttendanceEvent();
                                break;
                              default:
                                break;
                            }

                            Get.offAndToNamed("/home");
                          }
                        },
                        child: const Text("Create Event"),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
