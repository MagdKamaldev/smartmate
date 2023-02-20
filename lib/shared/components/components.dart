// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartmate/shared/styles/colors.dart';

Widget defaultDivider() => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    );

Widget defaultTextButton({
  required String text,
  required VoidCallback onpressed,
}) =>
    TextButton(
        onPressed: onpressed,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: defaultColor),
        ));

Widget defaultButton({
  double height = 40,
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 0.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: background,
        ),
        child: MaterialButton(
          onPressed: function,
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ));

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function onSubmit,
  required Function onTab,
  required Function onChanged,
  Function? validate,
  bool isPassword = false,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      validator: (value) {
        return validate!(value);
      },
      controller: controller,
      keyboardType: type,
      enabled: isClickable,
      obscureText: isPassword,
      onFieldSubmitted: (s) {
        onSubmit();
      },
      onChanged: (s) => onChanged,
      onTap: () => onTab(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
          color: defaultColor,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                  color: defaultColor,
                ),
                onPressed: () {
                  suffixPressed!();
                },
              )
            : null,
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: defaultColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey)),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

void navigateTo(context, widget) => Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context, CupertinoPageRoute(builder: (context) => widget), (route) {
      return false;
    });
void showToast({
  required String text,
  required ToasStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      fontSize: 16,
    );

enum ToasStates { succes, error, warning }

Color chooseToastColor(ToasStates state) {
  Color color;
  switch (state) {
    case ToasStates.succes:
      color = Colors.green;
      break;
    case ToasStates.error:
      color = Colors.red;
      break;
    case ToasStates.warning:
      return Colors.amber;
  }
  return color;
}

void openSnackBar(context, messege, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: "",
        onPressed: () {},
        textColor: Colors.white,
      ),
      content: Center(
        child: Text(
          messege,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
      )));
}
