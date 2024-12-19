import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../widgets/department_item.dart';
import '../providers/students_provider.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    final Map<Department, int> departmentStudentCounts = {
      for (var department in Department.values)
        department: students
            .where((student) => student.department == department)
            .length,
    };

    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: Department.values.length,
        itemBuilder: (context, index) {
          final department = Department.values[index];
          return DepartmentItem(
            name: departmentNames[department]!,
            studentCount: departmentStudentCounts[department] ?? 0,
            icon: departmentIcons[department]!,
            color: departmentColors[department]!,
          );
        },
      ),
    );
  }
}
