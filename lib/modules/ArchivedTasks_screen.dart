import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/componanets.dart';
import 'package:todo_app/contracts.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class ArchivedTasks_Screen extends StatelessWidget {
  const ArchivedTasks_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archeiveTasks;
        return ConditionalBuilder(
          condition: tasks.length > 0,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(tasks[index], context),
              separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                  ),
              itemCount: tasks.length),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'No Tasks Yet , Please Add Some Tasks',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
