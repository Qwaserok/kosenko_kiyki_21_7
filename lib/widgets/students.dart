import 'package:flutter/material.dart';
import 'package:kosenko_kiyki_21_7/models/student.dart';
import 'package:kosenko_kiyki_21_7/widgets/student_item.dart';
import 'package:kosenko_kiyki_21_7/widgets/newstudent.dart';

class Students extends StatefulWidget {
  final List<Student> students;
  const Students({super.key, required this.students});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  late List<Student> studentsList;
  Student? _lastDeletedStudent;
  int? _lastDeletedIndex;

  @override
  void initState() {
    super.initState();
    studentsList = widget.students;
  }

  void _addOrEditStudent({Student? student, int? index}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewStudent(
          student: student,
          onSave: (newStudent) {
            setState(() {
              if (index != null) {
                studentsList[index] = newStudent;
              } else {
                studentsList.add(newStudent);
              }
            });
          },
        );
      },
    );
  }

  void _deleteStudent(int index) {
    setState(() {
      _lastDeletedStudent = studentsList[index];
      _lastDeletedIndex = index;
      studentsList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Видалено: ${_lastDeletedStudent!.firstName} ${_lastDeletedStudent!.lastName}'),
        action: SnackBarAction(
          label: 'Відміна',
          onPressed: _undoDelete,
        ),
      ),
    );
  }

  void _undoDelete() {
    if (_lastDeletedStudent != null && _lastDeletedIndex != null) {
      setState(() {
        studentsList.insert(_lastDeletedIndex!, _lastDeletedStudent!);
      });
      _lastDeletedStudent = null;
      _lastDeletedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учні'),
        backgroundColor: const Color.fromARGB(255, 19, 240, 141),
      ),
      body: ListView.builder(
        itemCount: studentsList.length,
        itemBuilder: (context, index) {
          final student = studentsList[index];
          return Dismissible(
            key: ValueKey(student),
            background: Container(color: Colors.red),
            onDismissed: (direction) => _deleteStudent(index),
            child: InkWell(
              onTap: () => _addOrEditStudent(student: student, index: index),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditStudent(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
