import 'package:flutter/material.dart';
import 'package:kosenko_kiyki_21_7/models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  const StudentItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = student.gender == Gender.male ? Colors.blue[50] : Colors.pink[50];

    return Container(
      color: backgroundColor,
      child: ListTile(
        title: Text(
          '${student.firstName} ${student.lastName} - ${student.grade}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 112, 219)),
        ),
        trailing: Icon(departmentIcons[student.department], color: const Color.fromARGB(255, 183, 255, 0)),
      ),
    );
  }
}
