import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> students;
  final bool isLoading;
  final String? errorMessage;

  StudentsState({
    required this.students,
    required this.isLoading,
    this.errorMessage,
  });

  StudentsState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StudentsState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(students: [], isLoading: false));

  Student? _removedStudent;
  int? _removedIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await Student.remoteGetList();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final student = await Student.remoteCreate(
          firstName, lastName, department, gender, grade);
      state = state.copyWith(
        students: [...state.students, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> editStudent(
    int index,
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedStudent = await Student.remoteUpdate(
        state.students[index].id,
        firstName,
        lastName,
        department,
        gender,
        grade,
      );
      final updatedList = [...state.students];
      updatedList[index] = updatedStudent;
      state = state.copyWith(students: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void deleteStudent(int index) {
    _removedStudent = state.students[index];
    _removedIndex = index;
    final updatedList = [...state.students];
    updatedList.removeAt(index);
    state = state.copyWith(students: updatedList);
  }

  void undoDelete() {
    if (_removedStudent != null && _removedIndex != null) {
      final updatedList = [...state.students];
      updatedList.insert(_removedIndex!, _removedStudent!);
      state = state.copyWith(students: updatedList);
    }
  }

  Future<void> removeFirebase() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (_removedStudent != null) {
        await Student.remoteDelete(_removedStudent!.id);
        _removedStudent = null;
        _removedIndex = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final studentProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {
  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});
