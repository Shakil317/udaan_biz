import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  /// User Details
  static const dbName = "NoteBook.db";
  static const dbVersion = 2;
  static const tableName = "Users";
  static const userName = "name";
  static const userNumber = "number";
  static const  columnId = "id";
  static const  userId = "userId_321";
  static const image = "image";
  static const userCollections = "userCollections";

  /// User Transition Details
  static const transactionsTable = "TransactionsHistory";
  static const receiveMoney = "receivedMoney";
  static const loanedMoney = "loanedMoney";
  static const remarkItemName = "remarkItem";
  static const currentDate = "currentDate";
  static const currentTime = "currentTime";
  static const debitId = "debitId";
  static const creditId = "creditId";
  static const transitionId = "transitionId";
  static const type = "status";
  static const myCollation = "yourCollection";
  static const usersID = "usersId";

  /// User Profile Details
  static const myProfileTable = "profile";
  static const  profileId = "profileId";
  static const  shopName = "shopName";
  static const  profileContact = "phone";
  static const  bankInfo = "bankInfo";
  static const  qrImage = "qrImage";
  static const  prImage = "prImage";
  static const  uploadStamp = "uploadStamp";

  Future<Database> insertDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    final db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) {
        db.execute("CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $userId INTEGER, $userName TEXT, $userNumber TEXT, $image TEXT, $userCollections TEXT)");
        db.execute("CREATE TABLE $transactionsTable($transitionId INTEGER PRIMARY KEY AUTOINCREMENT,$debitId INTEGER,$creditId INTEGER, $loanedMoney TEXT, $receiveMoney TEXT, $remarkItemName TEXT, $currentDate TEXT, $currentTime TEXT, $type TEXT, $myCollation TEXT, $usersID TEXT)");
        db.execute("CREATE TABLE $myProfileTable($profileId TEXT PRIMARY KEY,$shopName TEXT,$profileContact TEXT, $bankInfo TEXT, $prImage TEXT, $qrImage TEXT,$uploadStamp TEXT)");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 3) {
          db.execute(
              "CREATE TABLE IF NOT EXISTS $transactionsTable($transitionId INTEGER PRIMARY KEY AUTOINCREMENT, $debitId INTEGER, $creditId INTEGER, $loanedMoney TEXT, $receiveMoney TEXT, $remarkItemName TEXT, $currentDate TEXT, $currentTime TEXT, $type TEXT,  $myCollation TEXT, $usersID TEXT)");
          db.execute(
              "CREATE TABLE IF NOT EXISTS $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $userId INTEGER, $userName TEXT, $userNumber TEXT, $image TEXT, $userCollections TEXT)");
          db.execute(
              "CREATE TABLE IF NOT EXISTS $myProfileTable($profileId TEXT PRIMARY KEY,$shopName TEXT,$profileContact TEXT, $bankInfo TEXT, $prImage TEXT, $qrImage TEXT, $uploadStamp TEXT)");
        }
      },
    );
    return db;
  }
  Future<int> insertUser(Map<String, dynamic> users)async{
    var db = await insertDatabase();
    return  db.insert(tableName, users);
  }
  Future<int> updateUser(Map<String, dynamic> users,int id)async{
    var db = await insertDatabase();
    return   db.update(tableName, users,where: "id=?",whereArgs: [id]);
  }
  Future<int> deleteUser(int id)async{
    var db = await insertDatabase();
    return await  db.delete(tableName, where: "id=?",whereArgs: [id]);
  }


  Future<List<Map<String,dynamic>>> getUser()async{
    var db = await insertDatabase();
    return   db.query(tableName);
  }
  // Insert Transition Data
  Future<int> insertTransition(Map<String, dynamic> transitionHistory)async{
    var db = await insertDatabase();
    return  db.insert(transactionsTable, transitionHistory);
  }
  Future<int> updateTransition(Map<String, dynamic> transition,int transitionId)async{
    var db = await insertDatabase();
    return   db.update(transactionsTable, transition,where: "transitionId=?",
        whereArgs: [transitionId],);
  }
  Future<int> deleteTransition(int transitionId) async {
    var db = await insertDatabase();
    return await db.delete(transactionsTable, where: "transitionId = ?", whereArgs: [transitionId]);
  }

  /// await db.query('transitions', where: 'userId = ?', whereArgs: [userId]);
  ///db.query(transactionsTable)
  Future<List<Map<String,dynamic>>> getTransition({required var userId})async{
    var db = await insertDatabase();
    return   db.query(transactionsTable,
      where: 'usersId = ?',
      whereArgs: [userId],
      orderBy: '$currentDate ASC',);
  }

  ///Insert  Profile
  Future<int> insertMyProfile(Map<String, dynamic> myProfile)async{
    var db = await insertDatabase();
    return  db.insert(myProfileTable, myProfile);
  }
  Future<int> updateMyProfile(Map<String, dynamic> myProfile, String profileId) async {
    var db = await insertDatabase();
    return db.update(myProfileTable, myProfile, where: "profileId = ?", whereArgs: [profileId]);
  }
  Future<int> deleteMyProfile(int myProfileDeleteId)async{
    var db = await insertDatabase();
    return await  db.delete(myProfileTable, where: "profileId=?",whereArgs: [myProfileDeleteId]);
  }
  Future<List<Map<String,dynamic>>> getMyProfile()async{
    var db = await insertDatabase();
    return   db.query(myProfileTable);
  }
}

