import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';
import 'game_view.dart'; // Import your GameView

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _pseudoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            if (userViewModel.isLoggedIn) {
              // Display GameView directly
              return GameView(playerId: userViewModel.currentUser!.id);
            } else {
              // Afficher le formulaire de connexion
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _pseudoController,
                        decoration: const InputDecoration(labelText: 'Pseudo'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre pseudo';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true, // Cache les caractères tapés
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (userViewModel.errorMessage.isNotEmpty)
                        Text(
                          userViewModel.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool success = await userViewModel.login(
                              _pseudoController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              // No navigation needed, GameView will be displayed
                            }
                          }
                        },
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),

    );
  }
}