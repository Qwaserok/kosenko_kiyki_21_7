import 'package:flutter/material.dart';
import 'package:kosenko_kiyki_21_7/models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const NewStudent({super.key, this.student, required this.onSave});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int? _grade;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _selectedDepartment = widget.student!.department;
      _selectedGender = widget.student!.gender;
      _grade = widget.student!.grade;
    }
  }

  void _saveStudent() {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;

    if (firstName.isEmpty || lastName.isEmpty || _selectedDepartment == null || _selectedGender == null || _grade == null) {
      return;
    }

    final newStudent = Student(
      firstName: firstName,
      lastName: lastName,
      department: _selectedDepartment!,
      grade: _grade!,
      gender: _selectedGender!,
    );

    widget.onSave(newStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'Ім’я'),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Прізвище'),
          ),
          DropdownButtonFormField<Department>(
            value: _selectedDepartment,
            decoration: const InputDecoration(labelText: 'Відділ'),
            items: Department.values.map((dept) {
              return DropdownMenuItem(
                value: dept,
                child: Text(dept.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedDepartment = value),
          ),
          DropdownButtonFormField<Gender>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Стать'),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedGender = value),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Оцінка'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final parsedGrade = int.tryParse(value);
              if (parsedGrade != null && parsedGrade >= 0) {
                _grade = parsedGrade;
              }
            },
          ),
          ElevatedButton(
            onPressed: _saveStudent,
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }
}
