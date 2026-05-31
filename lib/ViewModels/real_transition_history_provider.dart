import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../models/real_transition_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui' as ui;
class RealTransitionHistoryProvider with ChangeNotifier {
  final DatabaseReference _rootRef = FirebaseDatabase.instance.ref().child("TransitionData");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController receiveAmountController = TextEditingController();
  TextEditingController loanedAmountController = TextEditingController();
  TextEditingController dateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController timeController = TextEditingController(text: DateFormat('hh:mm a').format(DateTime.now()));
  TextEditingController productRemarkController = TextEditingController();
  ScrollController transitionScrollController = ScrollController();
  final LocalAuthentication localAuth = LocalAuthentication();
  final GlobalKey savePdfKey = GlobalKey();
  List<RealTransitionModel> transitionList = [];
  double yourCollectionData = 0.0;
  double amount = 0.0;
  bool isLoading = false;
  String? customersId;
  String? get customerId => customersId;
  String? get _ownerUid => _auth.currentUser?.uid;
  void setCustomer(String? custId) {
    customersId = custId;
    transitionList.clear();
    notifyListeners();
  }
  Future<void> addNewTransition(BuildContext context,
      {required String status}) async {
    if (_ownerUid == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }
    if (customersId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Customer not selected")));
      return;
    }

    try {
      isLoading = true;
      notifyListeners();
      final transitionKey = const Uuid().v4();
      final creditId = const Uuid().v1().replaceAll('-', '').substring(0, 6);
      final debitId = const Uuid().v1().replaceAll('-', '').substring(0, 6);
      final loaned = loanedAmountController.text.trim();
      final received = receiveAmountController.text.trim();
      final model = RealTransitionModel(
        usersId: _ownerUid,
        transitionId: transitionKey,
        creditId: creditId,
        debitId: debitId,
        remarkItem: productRemarkController.text.trim(),
        loanedMoney: loaned,
        receivedMoney: received,
        currentDate: dateController.text.trim(),
        currentTime: timeController.text.trim(),
        isReceived: status.toString(),
        yourCollection: yourCollectionData.toString(),
      );
      await _rootRef.child(_ownerUid!).child(customersId!).child("transactions").child(transitionKey).set(model.toMap());
      await FirebaseDatabase.instance
          .ref()
          .child("Customers")
          .child(_ownerUid!)
          .child(customersId!)
          .update({
        "finalCollection": yourCollectionData,
        "lastUpdated": DateTime.now().toIso8601String(),
      });

      var updateUser = {
        "finalCollection":yourCollectionData.toString(),
      };
      await _rootRef.child(_ownerUid!).child(customersId!).update(updateUser);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (transitionScrollController.hasClients) {
          transitionScrollController.animateTo(
            transitionScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
      await fetchTransitions();
      clearControllers();
      isLoading = false;
      if(status == "isReceive"){
        var loanAmount = double.parse(receiveAmountController.text.toString());
        amount -=loanAmount;
      }else {
        var loanReceiveAmount = double.parse(loanedAmountController.text.toString());
        amount += loanReceiveAmount;
      }
      notifyListeners();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Saved")));
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
  Future<void> fetchTransitions() async {
    if (_ownerUid == null || customersId == null) return;
    final ref =
        _rootRef.child(_ownerUid!).child(customersId!).child('transactions');
    ref.onValue.listen((event) {
      transitionList.clear();
      if (event.snapshot.exists) {
        for (var child in event.snapshot.children) {
          final map = Map<String, dynamic>.from(child.value as Map);
          final model = RealTransitionModel.fromMap(map);
          transitionList.add(model);
        }
      }
      transitionList.sort((a, b) {
        try {
          final d1 =
              DateFormat('dd-MM-yyyy').parse(a.currentDate ?? '01-01-2000');
          final d2 =
              DateFormat('dd-MM-yyyy').parse(b.currentDate ?? '01-01-2000');
          return d1.compareTo(d2);
        } catch (_) {
          return 0;
        }
      });
      _recalculateCollections();
      notifyListeners();
    }, onError: (err) {
      debugPrint("Listener error: $err");
    });
  }

  void deleteTransitionWithAuth(BuildContext context, String transitionId)async{
    bool isAvailable;
    isAvailable = await localAuth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");
    if(isAvailable){
      bool results = await localAuth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options:   const AuthenticationOptions(
            useErrorDialogs: true,
          //biometricOnly: true,
        ),
        // options:  biometricOnly: true,
      );
      if(results){if (_ownerUid == null || customersId == null) return;
        try {
          await _rootRef
              .child(_ownerUid!)
              .child(customersId!)
              .child('transactions')
              .child(transitionId).remove();
          transitionList.removeWhere((t) => t.transitionId == transitionId);
          _recalculateCollections();
          await FirebaseDatabase.instance
              .ref()
              .child("Customers")
              .child(_ownerUid!)
              .child(customersId!)
              .update({
            "finalCollection": yourCollectionData,
            "lastUpdated": DateTime.now().toIso8601String(),
          });
          Fluttertoast.showToast(msg: "Transaction Deleted Successfully!");
          await fetchTransitions();
        } catch (e) {
          debugPrint("❌ deleteTransition error: $e");
        }
        notifyListeners();
      }else{
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    }else{
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }
  }
  void _recalculateCollections() {
    double received = 0;
    double loaned = 0;
    for (var t in transitionList) {
      received += double.tryParse(t.receivedMoney ?? "0") ?? 0;
      loaned += double.tryParse(t.loanedMoney ?? "0") ?? 0;
    }
    yourCollectionData = loaned - received;
    notifyListeners();
  }
  void clearControllers() {
    receiveAmountController.clear();
    loanedAmountController.clear();
    productRemarkController.clear();
  }

  Future<void> selectedDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (picked != null) {
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
      final dateTime =
          DateTime(now.year, now.month, now.day, setTime.hour, setTime.minute);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      timeController.text = formattedTime;
    }
    notifyListeners();
  }
  Future<void> refresh() async => await fetchTransitions();

  Future<void> saveAndSharePDF() async {
    try {
      RenderRepaintBoundary boundary =
      savePdfKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);
      pdf.addPage(
        pw.Page(
          pageFormat:  const PdfPageFormat(8.0 * PdfPageFormat.cm, 13.0 * PdfPageFormat.cm),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imageProvider, fit: pw.BoxFit.contain,),
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
}

