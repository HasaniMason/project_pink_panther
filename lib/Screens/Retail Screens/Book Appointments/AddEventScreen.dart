import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../Widgets/InputTextFieldWidgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class AddEventScreen extends StatefulWidget {
  DateTime selectedDate;
  CalendarController calendarController;

  AddEventScreen(
      {super.key,
      required this.selectedDate,
        required this.calendarController
      });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController textEditingController = TextEditingController();

  TimeOfDay? selectedTime;

  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(context),
            Inputs(context),
            BottomInfo(context),
          ],
        ),
      ),
    );
  }

  Padding BottomInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Information before submitting:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              'Name: ${nameController.text}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              'Phone Number: ${phoneController.text}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              'Email: ${emailController.text}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              'Time: ${timeController.text}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 8.0, bottom: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  ///create a method to check if info is input correctly

                  //create event based off info input
                  final event = CalendarEventData(
                      title: 'Lash Appointment',
                      date: widget.selectedDate,
                      color: Colors.blue,
                      startTime: DateTime(
                          widget.selectedDate.year,
                          widget.selectedDate.month,
                          widget.selectedDate.day,
                          selectedTime?.hour ?? 7,
                          //selected time. If not input, chose 7 by default
                          selectedTime?.minute ?? 00),
                  //     description:
                  //         'Appointment w/ ${nameController.text}. Phone Number: ${phoneController.text}.  Email: ${emailController.text}. Date: ${widget.selectedDate} @ ${selectedTime ?? 'NO SPECIFIED TIME'}');
                  // widget.eventController.add(event
                  );

                 // print(event.description);
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Inputs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.3),
            borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: [
            //TextField to hold name
            InputTextFieldWidget(controller: nameController, hintText: 'Name'),

            //TextField to hold number
            InputTextFieldWidget(
                controller: phoneController, hintText: 'Phone Number'),

            InputTextFieldWidget(
                controller: emailController, hintText: 'Email'),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Drop down button
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Lashes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),

                  //button to prompt time picker widget
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      selectTime(); //method to invoke time picker widget
                    },
                    child: const Text(
                      "Select Time",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding Header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Column(
        children: [
          Text(
            'Book Appointment',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            "Fill out the from as much as possible. Appointments will be approved if available. Only lash appointments!",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black),
          ),

          Text(
            "Selected Date: ${widget.selectedDate.month}-${widget.selectedDate.day}-${widget.selectedDate.year}",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }

  Future<void> selectTime() async {
    //show time picker widget
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {

        selectedTime = picked;

        picked = picked?.replacing(
            hour: picked?.hourOfPeriod); //change to 12 hour format
        timeController.text = "${picked?.hour}:${picked?.minute}";
      });
    }
  }
}
