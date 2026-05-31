import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycalculator/ViewModels/database_helper.dart';
import 'package:mycalculator/models/transition_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
class TransitionHistoryProvider with ChangeNotifier{
  TextEditingController dateController = TextEditingController(text:DateFormat('dd-MM-yyyy').format(DateTime.now()),);
  TextEditingController timeController = TextEditingController(text: DateFormat('hh:mm a').format(DateTime.now()),);
  List<TransitionModels> transitionList = [];
  TextEditingController receiveAmountController = TextEditingController();
  TextEditingController productRemarkController = TextEditingController();
  TextEditingController loanedAmountController = TextEditingController();
  ScrollController transitionScrollController = ScrollController();
  final LocalAuthentication localAuth = LocalAuthentication();
  final GlobalKey sharePdfKey = GlobalKey();
  var amount = 0.0;
  var usersId = 0;
  int yourCollectionData  = 0;
  Future<void> addToListUser() async {
    transitionList.clear();
    final transitions = await DatabaseHelper().getTransition(userId: usersId);
    transitionList.addAll(transitions.map((t) => TransitionModels.fromMap(t)).toList());
    notifyListeners();
  }
  void insertNewTransition(BuildContext context, {required String status}) async {
    String generateId = const Uuid().v1();
    String creditId = generateId.replaceAll('-', '').substring(0, 6);
    String debitId = generateId.replaceAll('-', '').substring(0, 6);
    int totalLoanedMoney = 0;
    int totalReceivedMoney = 0;
    for (var element in transitionList) {
      if (element.loanedMoney != null && element.loanedMoney!.isNotEmpty) {
        totalLoanedMoney += int.tryParse(element.loanedMoney!) ?? 0;
      }
      if (element.receivedMoney != null && element.receivedMoney!.isNotEmpty) {
        totalReceivedMoney += int.tryParse(element.receivedMoney!) ?? 0;
      }
    }
    yourCollectionData = totalLoanedMoney - totalReceivedMoney;
    if(status == "isReceive"){
      var loanAmount = double.parse(receiveAmountController.text.toString());
      amount -=loanAmount;
    }else {
      var loanReceiveAmount = double.parse(loanedAmountController.text.toString());
      amount += loanReceiveAmount;
    }
    notifyListeners();
    var addTransition = {
      "transitionId": (DateTime.now().microsecondsSinceEpoch ~/ 10000) % 1000000,
      "debitId": debitId,
      "creditId": creditId,
      "usersId":usersId,
      "loanedMoney": loanedAmountController.text.toString(),
      "receivedMoney": receiveAmountController.text.toString(),
      "remarkItem": productRemarkController.text.toString(),
      "currentDate":dateController.text.toString(),
      "currentTime":timeController.text.toString(),
      "status" : status.toString(),
      "yourCollection":yourCollectionData.toString(),
    };
    var updateUser = {
      "userCollections":amount.toString(),
    };
    Future.delayed(const Duration(milliseconds: 300), () {
      if (transitionScrollController.hasClients) {
        transitionScrollController.animateTo(
          transitionScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    await DatabaseHelper().insertTransition(addTransition);
    await DatabaseHelper().updateUser(updateUser, usersId);
    showAmountTransition();
    notifyListeners();
    clearControllers();
  }

  void showAmountTransition() async {
    transitionList.clear();
    List<Map<String, dynamic>> transitionData = await DatabaseHelper().getTransition(userId: usersId);
    transitionList.addAll(transitionData.map((user)=>TransitionModels.fromMap(user)).toList());
    int totalLoanedMoney = 0;
    int totalReceivedMoney = 0;
    for (var element in transitionList) {
      if (element.loanedMoney != null && element.loanedMoney!.isNotEmpty) {
        totalLoanedMoney += int.tryParse(element.loanedMoney!) ?? 0;
      }
      if (element.receivedMoney != null && element.receivedMoney!.isNotEmpty) {
        totalReceivedMoney += int.tryParse(element.receivedMoney!) ?? 0;
      }
    }
    yourCollectionData = totalLoanedMoney - totalReceivedMoney;
    notifyListeners();
  }
  Future<void> selectedDate(BuildContext context) async{
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if(picked != null){
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      dateController.text = formattedDate;
    }
    notifyListeners();
  }
  Future<void> selectedTime(BuildContext context) async {
    TimeOfDay? setTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: "Cancel",
      confirmText: "Ok",
    );
    if (setTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, setTime.hour, setTime.minute);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      timeController.text = formattedTime;
    }
    notifyListeners();
  }

  void deleteTransition(BuildContext context, int index) async {
    final id = transitionList[index].transitionId;
    if (id != null) {
      final rows = await DatabaseHelper().deleteTransition(id);
      Fluttertoast.showToast(msg: "Deleted rows: $rows, ID: $id");
      
      showAmountTransition();
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: "transitionId is null!");
    }
  }
  void checkLocalAuthTransitionDelete(BuildContext context, int transitionId)async{
    bool isAvailable;
    isAvailable = await localAuth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");
    if(isAvailable){
      bool results = await localAuth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options: const AuthenticationOptions(
            useErrorDialogs: true
        ),
        //options:  AuthenticationOptions(biometricOnly: true),
      );
      if(results){
        await DatabaseHelper().deleteTransition(transitionId);
        showAmountTransition();
         notifyListeners();
      }else{
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    }else{
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }
  }
  @override
  void dispose() {
    clearControllers();
    super.dispose();
  }
  void clearControllers(){
    productRemarkController.clear();
    loanedAmountController.clear();
    receiveAmountController.clear();
  }

  Future<void> captureAndSharePDF() async {
    try {
      RenderRepaintBoundary boundary =
      sharePdfKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(8.0 * PdfPageFormat.cm, 13.0 * PdfPageFormat.cm),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      final output = await getTemporaryDirectory();
      // String userName = userProfile.users[widget.id!].name.toString();
      final file = File("${output.path}/transaction_report.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Transaction Report PDF from UdaanBiz',
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error creating or sharing PDF: $e");
      }
    }
  }

  Future<void> checkLocalAuthMultiDelete(
      BuildContext context, List<int> transitionIds) async {
    bool isAvailable = await localAuth.canCheckBiometrics;

    if (!isAvailable) {
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
      return;
    }

    bool result = await localAuth.authenticate(
      localizedReason: "Scan your fingerprint to delete selected transactions",
      options: const AuthenticationOptions(
        useErrorDialogs: true,
      ),
    );

    if (result) {
      for (var id in transitionIds) {
        await DatabaseHelper().deleteTransition(id);
      }

      Fluttertoast.showToast(msg: "${transitionIds.length} transactions deleted successfully");
      showAmountTransition();
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: "Permission Denied");
    }
  }

}