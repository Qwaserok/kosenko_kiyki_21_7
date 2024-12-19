import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(departmentIcons[student.department]),
      title: Text('${student.firstName} ${student.lastName}'),
      subtitle: Text('Grade: ${student.grade}'),
      trailing: student.gender == Gender.male
          ? const Icon(Icons.male, color: Colors.blue)
          : const Icon(Icons.female, color: Colors.pink),
    );
  }
}
