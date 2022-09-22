import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:whapp/constants/constants.dart';
import 'package:whapp/constants/theme.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/services/firebase_service.dart';
import 'package:whapp/widgets/keep_alive.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({Key? key}) : super(key: key);

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _fk = GlobalKey<FormBuilderState>();

  final _pageController = PageController();
  final _dateController = DateRangePickerController();

  EventType? eventType;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DateTime? start;
  DateTime? end;

  String? title;
  String? location;
  String? description;

  bool boardOnly = false;

  int? pointReward;
  int? capacity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 5,
              effect: const WormEffect(
                dotHeight: 10.0,
                dotWidth: 10.0,
                type: WormType.thin,
                activeDotColor: primaryColor,
              ), // your preferred effect
              onDotClicked: (index) {},
            ),
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: FormBuilder(
              key: _fk,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  KeepAlivePage(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: hPad,
                        child: Column(
                          children: [
                            Text(
                              "Let's get started",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Choose an event type",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 50),
                            OutlinedButton(
                              onPressed: () {
                                eventType = EventType.attendance;
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Text("Attendance Event"),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton(
                              onPressed: () {
                                eventType = EventType.volunteer;
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Text("Volunteer Event"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  KeepAlivePage(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: hPad,
                        child: Column(
                          children: [
                            Text(
                              "Next step",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Specify the date and time of the event",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 50),
                            SfDateRangePicker(
                              controller: _dateController,
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
                                      OutlinedButton(
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: startTime != null //
                                                ? startTime!
                                                : const TimeOfDay(hour: 12, minute: 0),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                startTime = value;
                                              });
                                            }
                                          });
                                        },
                                        child: Text(startTime != null ? startTime!.format(context) : "-"),
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
                                            initialTime: endTime != null //
                                                ? endTime!
                                                : (startTime != null
                                                    ? TimeOfDay(
                                                        hour: (startTime!.hour + 1) % 24,
                                                        minute: (startTime!.minute),
                                                      )
                                                    : const TimeOfDay(hour: 13, minute: 0)),
                                          ).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                endTime = value;
                                              });
                                            }
                                          });
                                        },
                                        child: Text(endTime != null ? endTime!.format(context) : "-"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                if (_dateController.selectedDate == null) {
                                  showError(context, "Date is not chosen.");
                                  return;
                                }

                                if (startTime == null || endTime == null) {
                                  showError(context, "Both start time and end time must be specified.");
                                  return;
                                }

                                if (startTime!.hour >= endTime!.hour && startTime!.minute >= endTime!.minute) {
                                  showError(context, "Start time cannot be later than the end time.");
                                  return;
                                }

                                var date = _dateController.selectedDate!;

                                start = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  startTime!.hour,
                                  startTime!.minute,
                                );

                                end = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  endTime!.hour,
                                  endTime!.minute,
                                );

                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: const Text("Continue"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  KeepAlivePage(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: hPad,
                        child: Column(
                          children: [
                            Text(
                              "Almost done!",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Fill out event title and location",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 50),
                            FormBuilderTextField(
                              name: "title",
                              style: Theme.of(context).textTheme.bodyMedium,
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
                                  title = val;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: "location",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textCapitalization: TextCapitalization.words,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                label: Text("Location"),
                                prefixIcon: Icon(Icons.place_outlined),
                              ),
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(errorText: "Enter the location"),
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  location = val;
                                }
                              },
                            ),
                            FormBuilderCheckbox(
                              name: "boardOnly",
                              title: Text(
                                "Board members only",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              contentPadding: EdgeInsets.zero,
                              activeColor: primaryColor,
                              onSaved: (val) {
                                if (val != null) {
                                  boardOnly = val;
                                }
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_fk.currentState!.saveAndValidate()) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                              child: const Text("Continue"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  KeepAlivePage(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: hPad,
                        child: Column(
                          children: [
                            Text(
                              "Almost done!",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Provide a description for the event",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 50),
                            FormBuilderTextField(
                              name: "description",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textCapitalization: TextCapitalization.sentences,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(label: Text("Description")),
                              textAlignVertical: TextAlignVertical.top,
                              maxLines: 6,
                              maxLength: 256,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(errorText: "Enter the description"),
                                ],
                              ),
                              onSaved: (val) {
                                if (val != null) {
                                  description = val;
                                }
                              },
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                if (_fk.currentState!.saveAndValidate()) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                              child: const Text("Continue"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  KeepAlivePage(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: hPad,
                        child: Column(
                          children: [
                            Text(
                              "Lastly!",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Specifiy additional information",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 50),
                            if (eventType == EventType.attendance) ...[
                              FormBuilderTextField(
                                name: "pointReward",
                                style: Theme.of(context).textTheme.bodyMedium,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text("Points Rewarded"),
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
                                    pointReward = int.parse(val);
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Points rewarded for attending the event",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            if (eventType == EventType.volunteer) ...[
                              FormBuilderTextField(
                                name: "capacity",
                                style: Theme.of(context).textTheme.bodyMedium,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text("Capacity"),
                                ),
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.numeric(errorText: "The input must be numeric"),
                                    FormBuilderValidators.min(0, errorText: "The number must be at least 0")
                                  ],
                                ),
                                onSaved: (val) {
                                  if (val != null) {
                                    capacity = int.parse(val);
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Maximum number of sign ups allowed",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                if (_fk.currentState!.saveAndValidate()) {
                                  if (eventType == EventType.attendance) {
                                    FirebaseService.instance.createEvent({
                                      "eventType": eventType!.name,
                                      "boardOnly": boardOnly,
                                      "title": title,
                                      "description": description,
                                      "location": location,
                                      "start": start,
                                      "end": end,
                                      "pointReward": pointReward,
                                      "signUpsId": [],
                                      "signUps": [],
                                    });
                                  }

                                  if (eventType == EventType.volunteer) {
                                    FirebaseService.instance.createEvent({
                                      "eventType": eventType!.name,
                                      "boardOnly": boardOnly,
                                      "title": title,
                                      "description": description,
                                      "location": location,
                                      "start": start,
                                      "end": end,
                                      "capacity": capacity,
                                      "checkedId": [],
                                      "signUpsId": [],
                                      "signUps": [],
                                      "totalRaised": 0,
                                    });
                                  }

                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text("Create Event"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
