// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../model/country.dart';
import '../model/user.dart';

class SQLUsers {
  static Future<void> createTables(sql.Database database) async {
    var tablname = 'usertable';
    var name = 'name';
    var surname = 'surname';
    var email = 'email';
    var password = 'password';
    var phone = 'phone';
    var bDay = 'bDay';
    var username = 'username';
    await database.execute('''CREATE TABLE $tablname(
      $name TEXT,
      $surname TEXT,
      $email TEXT,
      $password TEXT,
      $username TEXT,
      $phone TEXT,
      $bDay TEXT
    )''');
    var tablename = 'countrytable';
    var e164_cc = 'e164_cc';
    var iso2_cc = 'iso2_cc';
    var e164_sc = 'e164_sc';
    var geographic = 'geographic';
    var level = 'level';
    var example = 'example';
    var display_name = 'display_name';
    var full_example_with_plus_sign = 'full_example_with_plus_sign';
    var display_name_no_e164_cc = 'display_name_no_e164_cc';
    var e164_key = 'e164_key';

    await database.execute('''CREATE TABLE $tablename(
    $iso2_cc TEXT PRIMARY KEY NOT NULL,
    $name TEXT,
    $e164_cc TEXT,
    $e164_sc INT,
    $geographic INT,
    $level INT,
    $example TEXT,
    $display_name TEXT,
    $full_example_with_plus_sign TEXT,
    $display_name_no_e164_cc TEXT,
    $e164_key TEXT
  )''');
  }

  // id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,

  // createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP

  static Future<void> createCountry(List<Country> allcountries) async {
    final db = await SQLUsers.db();
    for (var element in allcountries) {
      final data = {
        'name': element.name,
        'e164_cc': element.e164_cc,
        'iso2_cc': element.iso2_cc,
        'e164_sc': element.e164_sc,
        'geographic': element.geographic == true ? 1 : 0,
        'level': element.level,
        'example': element.example,
        'display_name': element.display_name,
        'full_example_with_plus_sign': element.full_example_with_plus_sign,
        'display_name_no_e164_cc': element.display_name_no_e164_cc,
        'e164_key': element.e164_key
      };
      await db.insert('countrytable', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<sql.Database> db() async {
    return await sql.openDatabase(
      'databas.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<List<Country>> getAllCountries() async {
    final db = await SQLUsers.db();
    var r = await db.query('countrytable');
    var countries = <Country>[];
    for (var item in r) {
      countries.add(Country.fromMap(item));
    }
    return countries;
  }

  static Future<int> createItem(
      name, surname, email, password, username, phone, bDay) async {
    final db = await SQLUsers.db();

    final data = {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'username': username,
      'phone': phone,
      'bDay': bDay
    };
    final id = await db.insert('usertable', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<User>> getUsers() async {
    final db = await SQLUsers.db();
    var r = await db.query('usertable');
    var users = <User>[];
    for (var item in r) {
      users.add(User.fromMap(item));
    }
    return users;
  }

  static Future<List<Map<String, dynamic>>> getUser(String username) async {
    final db = await SQLUsers.db();
    return db.query('usertable',
        where: 'username = ?', whereArgs: [username], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
    final db = await SQLUsers.db();
    return db.query('usertable',
        where: 'email = ?', whereArgs: [email], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getUserByPhone(String phone) async {
    final db = await SQLUsers.db();
    return db.query('usertable',
        where: 'phone = ?', whereArgs: [phone], limit: 1);
  }

  static Future<User?> login(String username, String password) async {
    final db = await SQLUsers.db();
    var user = <User>[];
    User? me;
    var uss = await db.query('usertable',
        where: 'username = ? OR email=? AND password=?',
        whereArgs: [username, username, password],
        limit: 1);
    if (uss.isNotEmpty) {
      for (var item in uss) {
        user.add(User.fromMap(item));
      }
      me = user.first;
    }
    return me;
  }

  static Future<int> updateItem(String name, String surname, String email,
      String password, String username, String phone, String bDay) async {
    final db = await SQLUsers.db();

    final data = {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'username': username,
      'phone': phone,
      'bDay': bDay,
    };

    final result = await db.update('usertable', data);
    return result;
  }

  static Future<void> deleteItem(String email) async {
    final db = await SQLUsers.db();
    try {
      // await db.delete('usertable');
      await db.delete('usertable', where: 'email = ?', whereArgs: [email]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }
}
