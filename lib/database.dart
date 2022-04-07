import 'package:advance_todo_list/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class database {
  Database? db;
  Future<Database> getDb() async {
    if (db == null) {
      db = await openDb();
      return db!;
    } else {
      print("get db initialized");
      return db!;
    }
  }

  Future<Database> openDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'taskNew.db'),
      onCreate: ((db, version) {
        return db.execute(
            'CREATE TABLE todoListNew(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, note TEXT, date TEXT, startTime TEXT, endTime TEXT, remind TEXT, repeat TEXT, color TEXT, status INTEGER)');
      }),
      version: 1,
    );
  }

  Future<void> insertTodo(todo_model todo) async {
    Database db = await getDb();
    await db.insert("todoListNew", todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("inserted");
  }

  Future<void> updateTodoStatus(todo_model todo) async {
    Database db = await getDb();

    await db.update("todoListNew", todo.toMap(),
        where: 'note = ?', whereArgs: [todo.note]);
  }

  Future<void> deleteTodo(String note) async {
    Database db = await getDb();
    await db.delete("todoListNew", where: 'note = ?', whereArgs: [note]);
  }

  Future<List<todo_model>> getTodo() async {
    Database db = await getDb();
    final List<Map<String, dynamic>> todoList = await db.query('todoListNew');
    return List.generate(todoList.length, (i) {
      return todo_model(
        id: todoList[i]['id'],
        title: todoList[i]['title'],
        note: todoList[i]['note'],
        date: todoList[i]['date'],
        startTime: todoList[i]['startTime'],
        endTime: todoList[i]['endTime'],
        remind: int.parse(todoList[i]['remind']),
        repeat: todoList[i]['repeat'],
        color: todoList[i]['color'],
        status: todoList[i]['status'],
      );
    });
  }
}
