import 'package:flutter/material.dart';
import '../core/services/user_service.dart';
import '../models/user_model.dart';
class UserViewModel extends ChangeNotifier {
  final UserRequest _userRequest = UserRequest();
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _error = '';

  bool _isLoggedIn = false;
  UserModel? _currentUser;
  int? _playerId; // Ajout de l'ID du joueur connecté

  List<UserModel> get users => _users;

  // La variable isLoading nous permet de mettre un état de chargement de nos données en attendant qu'elles s'affichent.
  bool get isLoading => _isLoading;
  String get errorMessage => _error;

  bool get isLoggedIn => _isLoggedIn; // Getter pour l'état de connexion
  UserModel? get currentUser => _currentUser; // Getter pour l'utilisateur connecté
  int? get playerId => _playerId; // Getter pour l'ID du joueur

  List<UserModel> _filteredUsers = [];
  List<UserModel> get filteredUsers => _filteredUsers;

  /*---------------------*/
  /* Lectures de données */
  /*---------------------*/
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _users = await _userRequest.getUsers();
      _filteredUsers = List.from(_users);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserById(int id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _users = await _userRequest.getUserById(id) as List<UserModel>;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUsersByLastname(String lastname) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _users = await _userRequest.getUserByLastname(lastname);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users
          .where((user) =>
      user.pseudo.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /*---------------------*/
  /* Ecriture de données */
  /*---------------------*/

  /* Méthode qui permet d'insérer des données en base */
  Future<void> addUser(String firstname, String lastname, String birthdate) async {
    try {
      await _userRequest.insertUser(firstname, lastname, birthdate);
      await fetchUsers();
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  /* Méthode qui permet de modifier des données en base */
  Future<void> updateUser(int id, {String? firstname, String? lastname, String? birthdate}) async {
    try {
      await _userRequest.updateUser(id, firstname: firstname, lastname: lastname, birthdate: birthdate);
      await fetchUsers();
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  /* Méthode qui permet de supprimer des données en base */
  Future<void> deleteUser(int id) async {
    try {
      await _userRequest.deleteUser(id);
      await fetchUsers();
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  /*---------------------*/
  /* Connexion           */
  /*---------------------*/
  Future<bool> login(String pseudo, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      List<UserModel> users = await _userRequest.getUsers();

      for (var user in users) {
        if (user.pseudo == pseudo && user.password == password) {
          _currentUser = user;
          _isLoggedIn = true;
          _error = '';
          _playerId = user.id;
          notifyListeners();
          return true;
        }
      }
      _isLoggedIn = false;
      _error = 'Identifiants incorrects.';
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _playerId = null;
    notifyListeners();
  }
}