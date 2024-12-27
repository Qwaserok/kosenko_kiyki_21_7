import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int _grade = 50;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentProvider).students[widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _grade = student.grade;
      _selectedGender = student.gender;
      _selectedDepartment = student.department;
    }
  }

  void _saveStudent() async {
    if (_selectedDepartment == null || _selectedGender == null) return;

    if (widget.studentIndex != null) {
      await ref.read(studentProvider.notifier).editStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    } else {
      await ref.read(studentProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentProvider);
    if(state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Student',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Department>(
              value: _selectedDepartment,
              decoration: InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: Department.values.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Row(
                    children: [
                      Icon(
                        departmentIcons[dept],
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Text(dept.toString().split('.').last.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedDepartment = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Gender>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: Gender.values.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender.toString().split('.').last.toUpperCase(),
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grade:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _grade.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: Colors.deepPurple,
                  inactiveColor: Colors.deepPurple.shade100,
                  label: '$_grade',
                  onChanged: (value) => setState(() => _grade = value.toInt()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveStudent,
              child: const Text(
                'Save Student',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Цвет текста кнопки.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
