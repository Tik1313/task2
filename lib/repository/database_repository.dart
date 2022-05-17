import '../model/country.dart';
import '../model/user.dart';
import 'database.dart';

class DatabaseRepository {
  Future<User?> getUserByPhone(String phone) async {
    var userdb = await SQLUsers.getUserByPhone(phone);
    var users = <User>[];
    User? user;
    if (userdb.isNotEmpty) {
      users.add(User.fromMap(userdb.first));
      user = users.first;
    }
    return user;
  }

  Future<User?> getUserByEmail(String email) async {
    var userdb = await SQLUsers.getUserByEmail(email);
    var users = <User>[];
    User? user;
    if (userdb.isNotEmpty) {
      users.add(User.fromMap(userdb.first));
      user = users.first;
    }
    return user;
  }

  Future<User?> getUserByUsername(String username) async {
    var userdb = await SQLUsers.getUser(username);
    var users = <User>[];
    User? user;
    if (userdb.isNotEmpty) {
      users.add(User.fromMap(userdb.first));
      user = users.first;
    }
    return user;
  }

  Future<void> addItem(User user) async {
    await SQLUsers.createItem(user.getName, user.getSurName, user.getEmail,
        user.getPassword, user.getUserName, user.getPhone, user.getBDay);
    // _refreshJournals();
  }

  Future<List<User>> getItems() async {
    var users = await SQLUsers.getUsers();
    return users;
  }

  Future<User?> login(String username, String password) async {
    var me = await SQLUsers.login(username, password);
    return me;
  }

  Future<void> updateUser(User user) async {
    await SQLUsers.updateItem(user.getName, user.getSurName, user.getEmail,
        user.getPassword, user.getUserName, user.getPhone, user.getBDay);
  }

  Future<void> delete(String email) async {
    SQLUsers.deleteItem(email);
  }

  Future<void> addCountry(List<Country> allcountries) async {
    await SQLUsers.createCountry(allcountries);
  }

  Future<List<Country>> getCounties() async {
    var countries = await SQLUsers.getAllCountries();
    return countries;
  }
}
