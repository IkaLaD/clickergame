import 'package:intl/intl.dart';

class UserModel {
  final int id;
  final String pseudo;
  final String birthdate;
  final String password;

  // Constructeur classique
  UserModel({
    required this.id,
    required this.pseudo,
    required this.birthdate,
    required this.password
  });

  /*
   * Un factory en Flutter est un constructeur particulier qui permet
   * de créer des objets en effectuant des traitements et
   * des vérifications supplémentaires sur les paramètres
   * avant l'instanciation de notre objet.
   * Ici, on convertit les données Json de notre api en objet User
   */
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_player'] ?? 0,
      pseudo: json['pseudo'] ?? 'Nom pseudo',
      birthdate: json['birthdate'] ?? 'Date inconnue',
      password: json['password'] ?? 'Mot de passe inconnu',
    );
  }

  // Méthode pour créer un UserModel à partir d'une Map (utile pour la base de données)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      pseudo: map['pseudo'] ?? 'Nom pseudo',
      birthdate: map['birthdate'],
      password: map['password'] ?? 'Mot de passe inconnu',
    );
  }

  // Méthode pour convertir un UserModel en Map (utile pour la base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pseudo': pseudo,
      'birthdate': birthdate,
    };
  }

  /*
   * Getter qui permet de récupérer l'âge d'une personne
   * à partir de sa date de naissance
   */
  int get age {
    try {
      DateTime birth = DateFormat('yyyy-MM-dd').parse(birthdate);
      DateTime now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

}