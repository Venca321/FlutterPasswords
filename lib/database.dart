
import 'package:encrypt/encrypt.dart';
import 'package:sqflite/sqflite.dart';

final iv = IV.fromLength(16);

String encrypt(text) {
  final key = Key.fromUtf8('my 32 length key................');
  final encrypter = Encrypter(AES(key));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}

String decrypt(text) {
  final key = Key.fromUtf8('my 32 length key................');
  final encrypter = Encrypter(AES(key));
  final decrypted = encrypter.decrypt(text, iv: iv);
  return decrypted;
}

Database getDatabase(){
  Database database = openDatabase("database.db", version: 1,
      onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE User (pin INTEGER, biometrics TEXT)');
      await db.execute('CREATE TABLE Records (name TEXT, username TEXT, password TEXT)');
      userRegister();
  }) as Database;
  return database;
}

void userRegister(){
  print("Register");
}

Future<Map> getUser() async {
  var db = getDatabase();
  List<Map> list = await db.rawQuery('SELECT * FROM User');
  await db.close();
  return list[0];
}

Future<List<Map>> getRecords() async {
  var db = getDatabase();
  List<Map> list = await db.rawQuery('SELECT * FROM Records');
  await db.close();
  return list;
}

Future<void> addRecord(name, username, password) async {
  var db = getDatabase();
  var encryptedName = encrypt(name);
  var encryptedUsername = encrypt(username);
  var encryptedPassword = encrypt(password);
  await db.transaction((txn) async {
    await txn.rawInsert(
      'INSERT INTO Records(name, username, password) VALUES($encryptedName, $encryptedUsername, $encryptedPassword)'
    );
  });
  await db.close();
}

Future<void> removeRecord(name, username, password) async {
  var db = getDatabase();
  var encryptedName = encrypt(name);
  var encryptedUsername = encrypt(username);
  var encryptedPassword = encrypt(password);
  await db.rawDelete(
    'DELETE FROM Records WHERE name = ?, username = ?, password = ?', 
    [encryptedName, encryptedUsername, encryptedPassword]
  );
  await db.close();
}

Future<void> editRecord(name, username, password, newName, newUsername, newPassword) async {
  var db = getDatabase();
  var encryptedName = encrypt(name);
  var encryptedUsername = encrypt(username);
  var encryptedPassword = encrypt(password);
  var newEncryptedName = encrypt(newName);
  var newEncryptedUsername = encrypt(newUsername);
  var newEncryptedPassword = encrypt(newPassword);
  await db.rawUpdate(
    'UPDATE Records SET name = ?, username = ?, password = ? WHERE name = ?, username = ?, password = ?',
    [newEncryptedName, newEncryptedUsername, newEncryptedPassword, encryptedName, encryptedUsername, encryptedPassword]
  );
  await db.close();
}
