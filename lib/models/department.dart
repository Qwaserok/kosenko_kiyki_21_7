import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }

const Map<Department, String> departmentNames = {
  Department.finance: 'Finance',
  Department.law: 'Law',
  Department.it: 'IT',
  Department.medical: 'Medical',
};

const Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.account_balance,
  Department.law: Icons.gavel,
  Department.it: Icons.computer,
  Department.medical: Icons.local_hospital,
};

const Map<Department, Color> departmentColors = {
  Department.finance: Colors.amber,
  Department.law: Colors.deepPurple,
  Department.it: Colors.blue,
  Department.medical: Colors.green,
};
