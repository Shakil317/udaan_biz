import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mycalculator/Utils/app_roots.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:mycalculator/calculator_screens/calculator_screen.dart';
import 'package:mycalculator/screens/downloas_pdf_screen.dart';
import 'package:mycalculator/screens/tamplete_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/about_app.dart';
import '../Utils/app_them.dart';
import '../ViewModels/transition_history_provider.dart';
class TransitionHistoryScreen extends StatefulWidget {
  final String? name;
  final int? id;
  final String? image;
  final String number;
  final double? totalAmount;

   const TransitionHistoryScreen(
      {super.key, this.name, required this.number, this.id, this.image, this.totalAmount});

  @override
  State<TransitionHistoryScreen> createState() =>
      _TransitionHistoryScreenState();
}

class _TransitionHistoryScreenState extends State<TransitionHistoryScreen> {
  late TransitionHistoryProvider creditProvider;
  bool isSelectionMode = false;
  Set<int> selectedIds = {};
  @override
  void initState() {
    AboutApp.enableScreenshot();
    super.initState();
    creditProvider =
        Provider.of<TransitionHistoryProvider>(context, listen: false);
    creditProvider.usersId = widget.id!;
    creditProvider.transitionList.clear();
    creditProvider.showAmountTransition();
    creditProvider.amount = widget.totalAmount??0.0;
  }

  @override
  Widget build(BuildContext context) {
    creditProvider =
        Provider.of<TransitionHistoryProvider>(context, listen: false);
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: const Color(0xff010c17),
        title: Text(widget.name ?? "Customer",
            style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppThem.appTextColor)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            radius: 21,
            backgroundColor: AppThem.appTextColor,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              backgroundImage: (widget.image != null && widget.image!.isNotEmpty)
                  ? FileImage(File(widget.image!))
                  : null,
              child: (widget.image == null || widget.image!.isEmpty)
                  ? Text(
                (widget.name != null && widget.name!.isNotEmpty)
                    ? widget.name![0].toUpperCase()
                    : '?',
                style:  TextStyle(
                  color: AppThem.appTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.picture_as_pdf, color: AppThem.appTextColor),
            onPressed: () {
              AppRoot.appRoutePush(
                context: context,
                page: DownloadsPdfScreenState(name: widget.name ?? ""),
              );
            },
          ),
        ],
      ),
      body: Consumer<TransitionHistoryProvider>(builder: (context, data, child) {
        data.transitionList.toSet().toList();
        return ListView.builder(
          controller: data.transitionScrollController,
          itemCount: data.transitionList.length,
          itemBuilder: (context, index) {
            var item = data.transitionList[index];
            bool isReceived = item.isReceived == 'isReceive';
            return isReceived ?
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: GestureDetector(
                onTap: () {
                  AppRoot.appAlertDialog(
                    context: context,
                    title: "Delete",
                    contentMes:
                    "Are you sure you want to delete this Receive Amount ₹${item.receivedMoney}?",
                    buttonText: "Delete",
                    toastMes: "Delete",
                    onConfirm: () {
                      creditProvider.checkLocalAuthTransitionDelete(
                          context, item.transitionId!);
                    },
                  );
                  creditProvider.showAmountTransition();
                },
                onLongPress: () {
                    isSelectionMode = true;
                    selectedIds.add(item.transitionId); // first selected item

                },
                child: Card(
                  color: Colors.white70,
                  elevation: 3,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.black12, width: 1.2),
                  ),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Receive Money",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Text(
                              "₹${item.receivedMoney}/-",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon:   Icon(Icons.south_west_rounded, color: Colors.green.shade500),
                              tooltip: "Send Message",
                              onPressed: () async{
                                String presetMessage =
                                    "नमस्ते ${widget.name}, आज आपने ₹${item.receivedMoney ?? '00'} जमा किए हैं। आपके विश्वास और भुगतान के लिए धन्यवाद!🙂";

                                final sms = Uri.parse(
                                    'sms:${widget.number.toString()}?body=${Uri.encodeComponent(presetMessage)}');

                                if (await canLaunchUrl(sms)) {
                                  await launchUrl(sms);
                                } else {
                                  Fluttertoast.showToast(msg: "Could not send message");
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Date: ${item.currentDate}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Time: ${item.currentTime}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.remarkItem ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                :
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 6),
              child: GestureDetector(
                onLongPress: () {
                  AppRoot.appAlertDialog(
                    context: context,
                    title: "Delete",
                    contentMes:
                    "Are you sure you want to delete this Loaned Amount ₹${item.loanedMoney}?",
                    buttonText: "Delete",
                    toastMes: "Delete",
                    onConfirm: () {
                      creditProvider.checkLocalAuthTransitionDelete(
                          context, item.transitionId);
                    },
                  );
                  creditProvider.showAmountTransition();
                },
                child:
                Card(
                  color: Colors.white70,
                  elevation: 3,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.black26, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Loaned Money",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Text(
                              "₹${item.loanedMoney}/-",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                                fontSize: 21,
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.north_east_rounded, color: Colors.redAccent),
                              tooltip: "Send Reminder Message",
                              onPressed: ()async {
                                String presetMessage =
                                    "नमस्ते ${widget.name}, आज ₹${item.loanedMoney ?? '00'} की एंट्री आपके उधारी खाते में जोड़ी गई है। कृपया अपनी नोटबुक में भी दर्ज कर लें। धन्यवाद! 🙏";
                                final sms = Uri.parse(
                                    'sms:${widget.number.toString()}?body=${Uri.encodeComponent(presetMessage)}');
                                if (await canLaunchUrl(sms)) {
                                  launchUrl(sms);
                                } else {
                                  throw 'Could not launch $sms';
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Date: ${item.currentDate}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Time: ${item.currentTime}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.remarkItem ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Consumer<TransitionHistoryProvider>(
        builder: (context, value, child) {
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          return SafeArea(
            child: Container(
              padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 10),
              width: MediaQuery.of(context).size.width * 1,
               height: MediaQuery.of(context).size.width / 4,
              decoration: const BoxDecoration(
                  color: Color(0xff010c17),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showAppDialog(
                              dialogTitle: "Received Money",
                              controllerType:
                                  creditProvider.receiveAmountController,
                              states: 'isReceive');
                        },
                        child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Container(
                            height: 50,
                            width: 130,
                            decoration: BoxDecoration(
                                color: AppThem.appBgColor,
                                borderRadius: BorderRadius.circular(30)),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: AppThem.appTextColor,
                                  size: 30,
                                ),
                                Text(
                                  "Receive",
                                  style: TextStyle(
                                    color: AppThem.appTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          "Your Collections",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppThem.appTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text("\u20B9 ${creditProvider.yourCollectionData}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppThem.collectionTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showAppDialog(dialogTitle: "Loaned Money", controllerType: creditProvider.loanedAmountController, states: 'isLoaned');
                          creditProvider.clearControllers();
                        },
                        child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Container(
                            height: 50,
                            width: 130,
                            decoration: BoxDecoration(
                                color: AppThem.appBgColor,
                                borderRadius: BorderRadius.circular(30)),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: AppThem.appTextColor,
                                  size: 30,
                                ),
                                 Text(
                                  "Loaned",
                                  style: TextStyle(
                                    color: AppThem.appTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showAppDialog({
    required String dialogTitle,
    required TextEditingController controllerType,
    required String states,
  }) {
    var creditProvider = Provider.of<TransitionHistoryProvider>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5+10,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(width: 3, color: Colors.orange),
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 20),
                      child: Text(
                        dialogTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppThem.appBgColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 55, top: 10),
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              maxLength: 5,
                              controller: controllerType,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "Enter amount here",
                                hintText: "Enter amount here",

                                hintStyle: TextStyle(color: AppThem.appBgColor),
                                labelStyle:
                                    TextStyle(color: AppThem.appBgColor),
                                prefixIcon: Icon(Icons.currency_rupee,
                                    color: AppThem.appBgColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            AppDialog.navigatePage(
                                context, const CalculateScreen());
                          },
                          icon: const Icon(
                            Icons.calculate,
                            color: AppThem.appBgColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, bottom: 10),
                          child: SizedBox(
                            width: 160,
                            height: 45,
                            child: TextField(
                              controller: creditProvider.dateController,
                              keyboardType: TextInputType.datetime,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "Current Date",
                                hintText: DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now()),
                                hintStyle:
                                    const TextStyle(color: AppThem.appBgColor),
                                labelStyle:
                                    const TextStyle(color: AppThem.appBgColor),
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    creditProvider.selectedDate(context);
                                  },
                                  icon: const Icon(
                                    Icons.date_range,
                                    color: AppThem.appBgColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 150,
                          height: 45,
                          child: TextField(
                            controller: creditProvider.timeController,
                            keyboardType: TextInputType.datetime,
                            style: const TextStyle(color: AppThem.appBgColor),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              labelText: "Current Time",
                              hintText:
                                  DateFormat('hh:mm a').format(DateTime.now()),
                              hintStyle:
                                  const TextStyle(color: AppThem.appBgColor),
                              labelStyle:
                                  const TextStyle(color: AppThem.appBgColor),
                              prefixIcon: IconButton(
                                onPressed: () {
                                  creditProvider.selectedTime(context);
                                },
                                icon: const Icon(
                                  Icons.more_time_rounded,
                                  color: AppThem.appBgColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: SizedBox(
                            width: 250,
                            child: TextField(
                              maxLength: 25,
                              controller:
                                  creditProvider.productRemarkController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(color: AppThem.appBgColor),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                labelText: "Remark Item",
                                hintText: "Remark Item",
                                hintStyle: TextStyle(color: AppThem.appBgColor),
                                labelStyle:
                                    TextStyle(color: AppThem.appBgColor),
                                prefixIcon: Icon(
                                  Icons.production_quantity_limits,
                                  color: AppThem.appBgColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            AppDialog.navigatePage(
                                context, const AdminTemplateListScreen(id: null,));
                          },
                          icon: const Icon(
                            Icons.shopping_bag_sharp,
                            color: AppThem.appBgColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppThem.appBgColor),
                          ),
                          onPressed: () {
                            if (controllerType.text.isNotEmpty ||
                                creditProvider.productRemarkController.text.isNotEmpty) {creditProvider.insertNewTransition(context, status: states.toString(),);
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill in Amount and Remark");
                            }
                          },
                          child:  Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppThem.appTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
