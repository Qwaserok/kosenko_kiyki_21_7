import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import 'newstudent.dart';
import 'student_item.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showAddOrEditModal(BuildContext context, WidgetRef ref, {Student? student, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: NewStudent(studentIndex: index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Directory',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: state.students.length,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemBuilder: (context, index) {
            final student = state.students[index];
            return Dismissible(
              key: ValueKey(student),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(right: 16.0),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                ref.read(studentProvider.notifier).deleteStudent(index);
                final container = ProviderScope.containerOf(context);
                ScaffoldMessenger.of(ref.context).showSnackBar(
                  SnackBar(
                    content: const Text('Student deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () => container.read(studentProvider.notifier).undoDelete(),
                    ),
                  ),
                ).closed.then((value) {
                  if (value != SnackBarClosedReason.action) {
                    ref.read(studentProvider.notifier).removeFirebase();
                  }
                });
              },
              child: InkWell(
                onTap: () => _showAddOrEditModal(context, ref, student: student, index: index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: StudentItem(student: student),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => _showAddOrEditModal(context, ref),
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            'Add',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
