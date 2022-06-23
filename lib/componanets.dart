import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget deafultTextFormField({
  required TextEditingController? controller,
  //final Function validate,
  TextInputType? type,
  required String? label,
  required Icon? prefix,
  Widget? suffix,
  bool isPassword = false,
  final GestureTapCallback? onTap,
}) =>
    TextFormField(
      onTap: onTap,
      keyboardType: type,
      controller: controller,
      obscureText: isPassword,
      // validator: validate!(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${model['time']}',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.black),
              ),
              backgroundColor: Color(0xFF6699CC),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(Icons.check_box),
                color: Colors.green),
            SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: Icon(Icons.archive),
              color: Colors.black,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDate(
          id: model['id'],
        );
      },
    );
