import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';
import '../contracts.dart';
import '../modules/ArchivedTasks_screen.dart';
import '../modules/DoneTasks_screen.dart';
import '../modules/newTasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(IntialAppState());
  static AppCubit get(context) => BlocProvider.of(context);
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archeiveTasks = [];
  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTasks_Screen(),
    DoneTasks_Screen(),
    ArchivedTasks_Screen(),
  ];

  List<String> screensTitle = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeButtomNavBar());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('DataBase Created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title Text, date TEXT, time TEXT,status TEXT)')
          .then((value) => print('Table Created'));
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('Database Opened');
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","New")');
      print('$id Inserted Successfully');
      emit(InsertToDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archeiveTasks = [];
    emit(GetDataFromDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archeiveTasks.add(element);
      });
      emit(GetDataFromDatabaseState());
    });
  }

  void changeBottomSheetShow({
    required bool isSshow,
    required IconData icon,
  }) {
    isBottomSheetShown = isSshow;
    fabIcon = icon;
    emit(ChangeBottomSheetShowState());
  }

  void updateData({required String status, required id}) {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      print('$status sabay el5araaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      getDataFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

  void deleteDate({required id}) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }
}
