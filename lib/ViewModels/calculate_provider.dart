import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import '../screens/user_screens.dart';
class CalculateProvider with ChangeNotifier {
  late String userInput = "";
  String result = "0";
  ScrollController scrollController = ScrollController();

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    '%',
    '0',
    '.',
    '='
  ];
  final LocalAuthentication localAuth = LocalAuthentication();
  void checkLocalAuth(BuildContext context)async{
    bool isAvailable;
    isAvailable = await localAuth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");
    if(isAvailable){
      bool results = await localAuth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options: const AuthenticationOptions(
          useErrorDialogs: true
        )
        //options:const AuthenticationOptions(biometricOnly: true),
      );
      if(results){
        AppDialog.navigatePage(context, UserScreens());
      }else{
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    }else{
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }

  }

  Color getColor(String text, BuildContext context) {
    if (text == "/" ||
        text == "x" ||
        text == "-" ||
        text == "%" ||
        text == "(" ||
        text == ")" ||
        text == "+") {
      return const Color.fromARGB(225, 252, 100, 100);
    }
    return Colors.white;
  }

  Color getBgColor(String text, BuildContext context) {
    if (text == "AC") {
      return const Color.fromARGB(255, 252, 100, 100);
    }
    if (text == "=") {
      return const Color.fromARGB(255, 32, 81, 27);
    }

    return const Color(0xFF1d2630);
  }

  void handleButton(String text, BuildContext context) {
    if (text == "AC") {
      userInput = "";
      result = "0";
    } else if (text == "=") {
      if (userInput.isNotEmpty) {
        result = calculate(context);
         userInput = result;
      }
      if (userInput.endsWith("0")) {
        result = result.replaceAll(".0", "");
      }
    } else if (text == "%") {
      if (userInput.isNotEmpty &&
          !isOperator(userInput[userInput.length - 1])) {
        userInput += text;
      }
    } else if (text == "backspace") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
      }
    } else {
      userInput += text;
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
    notifyListeners();
  }

  bool isOperator(String text) {
    return text == "/" ||
        text == "x" ||
        text == "+" ||
        text == "-" ||
        text == "%";
  }
  String calculate(BuildContext context) {
    try {
      var formattedInput =
          userInput.replaceAll('x', '*').replaceAll('%', '/100');
      var exp = Parser().parse(formattedInput);
      var evaluate = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluate.toString();
    } catch (e) {
      return "Wrong Calculate ${e.toString().toLowerCase()}";
    }
  }
}
