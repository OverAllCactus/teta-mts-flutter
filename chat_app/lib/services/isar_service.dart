import 'dart:io';

import 'package:chat_app/models/user/db_user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;
  late Directory tempDir;
  IsarService() {
    db = openDB();
  }

  Future<void> saveUser(DbUser newUser) async {
    print('saveUser run');
    final isar = await db;
    // isar.writeTxnSync<int>(() => isar.dbUsers.putSync(newUser));
    await isar.writeTxn(() async {
      await isar.dbUsers.put(newUser); // insert & update
    });
    print('saveUser done');
    print(newUser);
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      Directory dir = await getTemporaryDirectory();
      return await Isar.open([DbUserSchema],
          inspector: true, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }
}
