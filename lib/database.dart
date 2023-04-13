
import 'package:encrypt/encrypt.dart';
import 'package:sqflite/sqflite.dart';

final iv = IV.fromLength(16);

String encrypt(text) {
  final key = Key.fromUtf8('X3EhZ7eprfPZblJFChLHUWNVSJtpzEAa');
  final encrypter = Encrypter(AES(key));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}

String decrypt(text) {
  final key = Key.fromUtf8('X3EhZ7eprfPZblJFChLHUWNVSJtpzEAa');
  final encrypter = Encrypter(AES(key));
  final decrypted = encrypter.decrypt64(text, iv: iv);
  return decrypted;
}

Future<Database> getDatabase() async {
  //await deleteDatabase("database.db");
  Database database = await openDatabase("database.db", version: 1,
      onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE User (pin TEXT, biometrics TEXT)');
      await db.execute('CREATE TABLE Records (name TEXT, username TEXT, password TEXT)');
  });
  return database;
}

Future<void> userRegister(pin, biometrics) async {
  var db = await getDatabase();
  try{
    await db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO User(pin, biometrics) VALUES("$pin", "$biometrics")'
      );
    });
    await db.close();
  }
  catch(e){
    userRegister(pin, biometrics);
  }
}

Future<Map?> getUser() async {
  var db = await getDatabase();
  List<Map> list = await db.rawQuery('SELECT * FROM User');
  await db.close();
  try{
    return list[0];
  }
  catch(e){print(list);}
}

Future<List> getRecords() async {
  var db = await getDatabase();
  List<Map> list = await db.rawQuery('SELECT * FROM Records');
  await db.close();
  var decryptedList = [];
  for (var record in list){
    decryptedList.add(
      {"name": decrypt(record["name"]), "username": decrypt(record["username"]), "password": decrypt(record["password"])}
    );
  }
  return decryptedList;
}

Future<void> addRecord(name, username, password) async {
  var db = await getDatabase();
  if (name.length < 1 && username.length < 1 && password.length < 1){return;}
  var encryptedName = encrypt(name);
  var encryptedUsername = encrypt(username);
  var encryptedPassword = encrypt(password);
  await db.transaction((txn) async {
    await txn.rawInsert(
      'INSERT INTO Records(name, username, password) VALUES("$encryptedName", "$encryptedUsername", "$encryptedPassword")'
    );
  });
  await db.close();
}

Future<void> removeRecord(name, username, password) async {
  var db = await getDatabase();
  var encryptedName = encrypt(name);
  var encryptedUsername = encrypt(username);
  var encryptedPassword = encrypt(password);
  await db.rawDelete(
    'DELETE FROM Records WHERE name = ? and username = ? and password = ?', 
    [encryptedName, encryptedUsername, encryptedPassword]
  );
  await db.close();
}

Future<void> editRecord(name, username, password, newName, newUsername, newPassword) async {
  var db = await getDatabase();
  newName ??= name;
  newUsername ??= username;
  newPassword ??= password;
  var encryptedName = encrypt(name);
  var encryptedUsername = encrypt(username);
  var encryptedPassword = encrypt(password);
  var newEncryptedName = encrypt(newName);
  var newEncryptedUsername = encrypt(newUsername);
  var newEncryptedPassword = encrypt(newPassword);
  await db.rawUpdate(
    'UPDATE Records SET name = ?, username = ?, password = ? WHERE name = ? and username = ? and password = ?',
    [newEncryptedName, newEncryptedUsername, newEncryptedPassword, encryptedName, encryptedUsername, encryptedPassword]
  );
  await db.close();
}
