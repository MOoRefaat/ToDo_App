import 'dart:ffi';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/modules/ArchivedTasks_screen.dart';
import 'package:todo_app/modules/DoneTasks_screen.dart';
import 'package:todo_app/modules/newTasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'componanets.dart';
//import 'package:validators/validators.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contracts.dart';

class ToDoApp extends StatelessWidget {
  @override
  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  //DateTime datetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is InsertToDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[200],
          key: scafoldKey,
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[700],
            title: Text(cubit.screensTitle[cubit.currentIndex]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                }
              } else {
                scafoldKey.currentState
                    ?.showBottomSheet(
                        elevation: 20,
                        (context) => Container(
                              color: Colors.white,
                              padding: EdgeInsetsDirectional.all(15),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    deafultTextFormField(
                                      controller: titleController,
                                      //  type: TextInputType.text,
                                      label: 'Task Title',
                                      prefix: Icon(Icons.title),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    deafultTextFormField(
                                      //isPassword: false,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          //print(value!.format(context));
                                        });
                                      },
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      label: 'Task Time',
                                      prefix: Icon(Icons.watch_later),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    deafultTextFormField(
                                      //isPassword: false,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-07-01'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      label: 'Task Date',
                                      prefix: Icon(Icons.calendar_month),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetShow(isSshow: false, icon: Icons.edit);
                });
                cubit.changeBottomSheetShow(isSshow: true, icon: Icons.add);
              }
              // insertDatabase();
            },
            child: Icon(cubit.fabIcon),
            backgroundColor: Colors.blueGrey[700],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white70,
            elevation: 80,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              //setState(() {
              cubit.changeIndex(index);
              //});
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: 'New Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archived'),
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! GetDataFromDatabaseLoadingState,
            builder: (context) => cubit.screens[cubit.currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }
}
