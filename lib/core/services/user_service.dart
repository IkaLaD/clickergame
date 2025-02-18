import '../../models/user_model.dart';
import 'api_service.dart';

class UserRequest {
  final ApiService apiService = ApiService();

  /*---------------------*/
  /* Lectures de données */
  /*---------------------*/

  /*
  * Cette fonction permet de récupérer la liste complète des users
  */
  Future<List<UserModel>> getUsers() async {
    List<dynamic> data = await apiService.getRequest("get_users.php");
    return data.map((user) => UserModel.fromJson(user)).toList();
  }

  /*
  * Cette fonction permet de récupérer un utilisateur par son id
  */
  Future<UserModel?> getUserById(int id) async {
    Map<String, String> queryParams = {"id_user": id.toString()};
    List<dynamic> data = await apiService.getRequest("get_users.php", queryParams: queryParams);
    if (data.isNotEmpty) {
      return UserModel.fromJson(data.first);
    }
    return null;
  }

  /*
  * Cette fonction permet de récupérer un utilisateur par son nom
  */
  Future<List<UserModel>> getUserByLastname(String lastname) async {
    Map<String, String> queryParams = {"lastname": Uri.encodeComponent(lastname)};
    List<dynamic> data = await apiService.getRequest("get_users.php", queryParams: queryParams);
    return data.map((user) => UserModel.fromJson(user)).toList();
  }

  /*
  * Cette fonction permet de récupérer un utilisateur dont l'âge est supérieur à 18 ans
  * La condition est gérée directement dans la requête côté php.
  */
  Future<List<UserModel>> getAdultUsers(int age) async {
    Map<String, String> queryParams = {"age": age.toString()};
    List<dynamic> data = await apiService.getRequest("get_users.php", queryParams: queryParams);
    return data.map((userData) => UserModel.fromJson(userData)).toList();
  }

  /*
   * Cette fonction est un exemple de récupération de données multi-filtre
   */
  Future<List<UserModel>> getUsersByFilters({String? lastname, int? age}) async {
    Map<String, String> queryParams = {};
    if (lastname != null) queryParams['lastname'] = Uri.encodeComponent(lastname);
    if (age != null) queryParams['age'] = age.toString();

    List<dynamic> data = await apiService.getRequest("get_users.php", queryParams: queryParams);
    return data.map((userData) => UserModel.fromJson(userData)).toList();
  }

  /*---------------------*/
  /* Ecriture de données */
  /*---------------------*/

  // Cette méthode permet d'ajouter un nouvel utilisateur à la base
  Future<void> insertUser(String firstname, String lastname, String birthdate) async {
    await apiService.postRequest("post_users.php", {
      "action": "insert",
      "firstname": firstname,
      "lastname": lastname,
      "birthdate": birthdate
    });
  }

  // Cette méthode permet de modifier un utilisateur par son id.
  Future<void> updateUser(int id, {String? firstname, String? lastname, String? birthdate}) async {
    Map<String, dynamic> data = {
      "action": "update",
      "id_user": id.toString(),
    };
    if (firstname != null) data["firstname"] = firstname;
    if (lastname != null) data["lastname"] = lastname;
    if (birthdate != null) data["birthdate"] = birthdate;

    await apiService.postRequest("post_users.php", data);
  }

  // Cette méthode permet de supprimer un utilisateur par son id.
  Future<void> deleteUser(int id) async {
    await apiService.postRequest("post_users.php", {
      "action": "delete",
      "id_user": id.toString(),
    });
  }
}