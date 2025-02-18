import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../viewmodels/user_viewmodel.dart';

class UserForm extends StatefulWidget {
  final UserViewModel viewModel;
  final UserModel? user;

  const UserForm({super.key, required this.viewModel, this.user});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController(text: widget.user?.firstname ?? '');
    lastnameController = TextEditingController(text: widget.user?.lastname ?? '');
    selectedDate = widget.user != null ? DateTime.parse(widget.user!.birthdate) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? "Ajouter un utilisateur" : "Modifier l'utilisateur"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: firstnameController, decoration: const InputDecoration(labelText: "Prénom")),
          const SizedBox(height: 8),
          TextField(controller: lastnameController, decoration: const InputDecoration(labelText: "Nom")),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedDate != null ? "Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}" : "Choisir une date"),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () {
            if (firstnameController.text.isNotEmpty &&
                lastnameController.text.isNotEmpty &&
                selectedDate != null) {
              if (widget.user == null) {
                widget.viewModel.addUser(
                  firstnameController.text,
                  lastnameController.text,
                  DateFormat('yyyy-MM-dd').format(selectedDate!),
                );
              } else {
                widget.viewModel.updateUser(
                  widget.user!.id,
                  firstname: firstnameController.text,
                  lastname: lastnameController.text,
                  birthdate: DateFormat('yyyy-MM-dd').format(selectedDate!),
                );
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.user == null ? "Ajouter" : "Modifier"),
        ),
      ],
    );
  }
}