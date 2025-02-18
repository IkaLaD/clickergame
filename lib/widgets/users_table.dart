import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UsersTable extends StatelessWidget {
  final List<UserModel> users;
  final Function(UserModel) onEdit;
  final Function(int) onDelete;

  const UsersTable({
    super.key,
    required this.users,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      columns: const [
        DataColumn(label: Text("Nom")),
        DataColumn(label: Text("Prénom")),
        DataColumn(label: Text("Age")),
        DataColumn(label: Text("Actions")),
      ],
      rows: users.map((user) {
        return DataRow(cells: [
          DataCell(Text(user.lastname)),
          DataCell(Text(user.firstname)),
          DataCell(Text(user.age.toString())),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(user.id),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}