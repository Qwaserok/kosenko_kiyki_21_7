import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  Student? _lastDeletedStudent;
  int? _lastDeletedIndex;

  void addStudent(Student student) {
    state = [...state, student];
  }

  void editStudent(int index, Student updatedStudent) {
    final updatedList = [...state];
    updatedList[index] = updatedStudent;
    state = updatedList;
  }

  void deleteStudent(int index) {
    _lastDeletedStudent = state[index];
    _lastDeletedIndex = index;
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void undoDelete() {
    if (_lastDeletedStudent != null && _lastDeletedIndex != null) {
      final updatedList = [...state];
      updatedList.insert(_lastDeletedIndex!, _lastDeletedStudent!);
      state = updatedList;

      _lastDeletedStudent = null;
      _lastDeletedIndex = null;
    }
  }

  void clearAll() {
    state = [];
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) => StudentsNotifier(),
);
