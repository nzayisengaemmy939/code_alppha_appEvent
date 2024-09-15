import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationLinkController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date as needed
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context); // Format time as needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title:const  Text("Add Event"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.title, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.description, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    hintText: "Date",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.date_range, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: const InputDecoration(
                    hintText: "Time",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.access_time, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _locationLinkController,
                  decoration: const InputDecoration(
                    hintText: "Location link",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.link, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _locationNameController,
                  decoration: const InputDecoration(
                    hintText: "Location Name",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.location_on, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.single,
                      side: const BorderSide(width: 1, color: AppColors.font1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Send",
                      style: TextStyle(color: AppColors.font2),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
