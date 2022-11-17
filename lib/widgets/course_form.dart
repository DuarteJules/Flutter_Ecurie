import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/mongodb.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();

class CourseForm extends StatefulWidget {
  const CourseForm({Key? key}) : super(key: key);

  @override
  _CourseFormState createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final hourController = TextEditingController();
  final durationController = TextEditingController();
  final disciplineController = TextEditingController();
  final placeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    hourController.dispose();
    durationController.dispose();
    disciplineController.dispose();
    placeController.dispose();
    super.dispose();
  }

  static _createCourse(
      TextEditingController titleController,
      TextEditingController descriptionController,
      TextEditingController dateController,
      TextEditingController hourController,
      TextEditingController durationController,
      TextEditingController disciplineController,
      TextEditingController placeController) async {
    var collection = mongodb.getCollection("courses");
    var timestamp = DateTime.now();
    collection.insertOne({
      "title": titleController.text,
      "description": descriptionController.text,
      "date": dateController.text,
      "hour": hourController.text,
      "duration": durationController.text,
      "discipline": disciplineController.text,
      "place": placeController.text,
      "status": 0,
      "createdAt": timestamp,
      "teacher": "François",
      "participants": [],
    });
  }

  @override
  void initState() {
    dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        TextFormField(
          // The validator receives the text that the user has entered.
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Entrez le titre du cours',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Entrez du texte s'il vous plait";
            }
          },
          controller: titleController,
        ),
        TextField(
          controller: dateController, //editing controller of this TextField
          decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
              labelText: "Chosissez une date" //label text of field
              ),
          readOnly: true, //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime
                    .now(), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101));
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                dateController.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {
              print("Date is not selected");
            }
          },
        ),
        TextField(
          controller: hourController, //editing controller of this TextField
          decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
              labelText: "Choisissez une heure" //label text of field
              ),
          readOnly: true, //set it true, so that user will not able to edit text
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            if (selectedTime != null) {
              final text;
              text = selectedTime.format(context);
              setState(() {
                hourController.text = text;
              });
            }
          },
        ),
        TextFormField(
          // The validator receives the text that the user has entered.
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Entrez la description du cours',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Entrez du texte s'il vous plait";
            }
          },
          controller: descriptionController,
        ),
        TextFormField(
          // The validator receives the text that the user has entered.
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Entrez la durée du cours',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Entrez une durée s'il vous plaît";
            }
          },
          controller: durationController,
        ),
        TextFormField(
          // The validator receives the text that the user has entered.
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Entrez la discipline du cours',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Entrez du texte s'il vous plait";
            }
          },
          controller: disciplineController,
        ),
        ElevatedButton(
          onPressed: () async {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Le cours a bien été créé')),
              );
              await _createCourse(
                  titleController,
                  descriptionController,
                  dateController,
                  hourController,
                  durationController,
                  disciplineController,
                  placeController);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          child: const Text('Submit'),
        ),
      ]),
    );
  }
}
