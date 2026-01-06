import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:mycalculator/Utils/about_app.dart';
import 'package:mycalculator/Utils/app_them.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:provider/provider.dart';
import '../ViewModels/transition_history_provider.dart';
import '../ViewModels/user_profile_provider.dart';

class DownloadsPdfScreenState extends StatefulWidget {
  final int? id;
  final String? name;
  final String? usersData;

  const DownloadsPdfScreenState(
      {super.key, this.id, this.usersData, this.name});

  @override
  State<DownloadsPdfScreenState> createState() =>
      _DownloadsPdfScreenStateState();
}

class _DownloadsPdfScreenStateState extends State<DownloadsPdfScreenState> {
  late TransitionHistoryProvider creditProvider;
  final GlobalKey _shareKey = GlobalKey();
  // late UserProvider userProfile;

  @override
  void initState() {
    AboutApp.enableScreenshot();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false)
          .showProfileData();
      creditProvider =
          Provider.of<TransitionHistoryProvider>(context, listen: false);
      creditProvider.usersId = widget.id!;
      creditProvider.transitionList.clear();
      creditProvider.showAmountTransition();
    });
  }

  @override
  Widget build(BuildContext context) {
    creditProvider =
        Provider.of<TransitionHistoryProvider>(context, listen: false);
    return Scaffold(
      bottomSheet: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            color: AppThem.appBgColor,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 0.0,),
                  child: Text(
                    "Share Your Pdf:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("Save"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          creditProvider.captureAndSharePDF();
                        },
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserProfileProvider>(
          builder: (context, provider, child) {
            if (provider.userProfile.isEmpty) {
              return  Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.red,),
                  const SizedBox(height: 10,),
                  ElevatedButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppThem.appBarColor)),onPressed: () async{
                    await AppDialog.myProfileDialog(context);
                  }, child: const Text("Update Profile",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                ],
              ));
          }
            if (provider.userProfile.isEmpty) {
              return const Center(child: Text("No profile data found"));
            }
            final profile = provider.userProfile[0];
            return Center(
              child: RepaintBoundary(
                key: creditProvider.sharePdfKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration:  const BoxDecoration(
                          borderRadius:  BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: AppThem.appBgColor,
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(left: 10, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InstaImageViewer(
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: profile.profileImage != null
                                        ? FileImage(File(profile.profileImage!))
                                        : const AssetImage(
                                                "assets/images/udaan_biz_logo.png")
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      profile.shopName ?? "ABC Store",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21,color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.pink, size: 12),
                                      Text(profile.bankInfo ?? "ABC Area",style: const TextStyle(color: Colors.white),),
                                      const Icon(Icons.phone,
                                          color: Colors.pink, size: 12),
                                      Text(profile.phone ?? "6206731567",style: const TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(color: AppThem.appBgColor),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FixedColumnWidth(30),
                            1: FixedColumnWidth(80),
                            2: FixedColumnWidth(90),
                            3: FixedColumnWidth(50),
                            4: FixedColumnWidth(50),
                            5: FixedColumnWidth(60),
                          },
                          children: [
                            const TableRow(
                              decoration:
                                  BoxDecoration(color: AppThem.appBgColor),
                              children: [
                                Center(
                                    child: Text("No",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                                Center(
                                    child: Text("Date",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                                Center(
                                    child: Text("RemarkItem",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                                Center(
                                    child: Text("Debit(↑)",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                                Center(
                                    child: Text("Credit(↓)",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                                Center(
                                    child: Text("AllDebit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12))),
                              ],
                            ),
                            ...List.generate(
                                creditProvider.transitionList.length, (index) {
                              var data = creditProvider.transitionList[index];
                              return TableRow(
                                children: [
                                  Center(
                                      child: Text((index + 1).toString(),
                                          style:
                                              const TextStyle(fontSize: 10))),
                                  Center(
                                      child: Text("${data.currentDate}",
                                          style:
                                              const TextStyle(fontSize: 10))),
                                  Center(
                                      child: Text(data.remarkItem ?? "---",
                                          style:
                                              const TextStyle(fontSize: 10))),
                                  Center(
                                      child: Text(data.loanedMoney ?? "--",
                                          style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 10))),
                                  Center(
                                      child: Text(data.receivedMoney ?? "--",
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 10))),
                                  Center(
                                      child: Text(
                                          data.receivedMoney == null
                                              ? "---"
                                              : data.loanedMoney != null
                                                  ? "${data.loanedMoney}"
                                                  : "---",
                                          style:
                                              const TextStyle(fontSize: 10))),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),

                      // Total
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Text("Total Due Amount"),
                            const Spacer(),
                            Text("₹${creditProvider.yourCollectionData}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: InstaImageViewer(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:  Colors.orangeAccent,
                                            width: 1),
                                      ),
                                      child: profile.qrImage != null
                                          ? Image.file(File(profile.qrImage!),
                                              fit: BoxFit.cover)
                                          : const Image(
                                              image: AssetImage(
                                                  "assets/images/shakil_upi_scaner.jpg")),
                                    ),
                                  ),
                                ),
                                const Text("Scan QR",
                                    style:
                                        TextStyle(color: AppThem.appBgColor)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "Please deposit due amount \n to us by this QR code. Zoom-in \n this code take a Screenshot and \n  make payment.",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black38),
                              ),
                            ),
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: InstaImageViewer(
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.orangeAccent,
                                            width: 1),
                                      ),
                                      child: profile.uploadStamp != null
                                          ? Image.file(
                                              File(profile.uploadStamp!),
                                              fit: BoxFit.cover)
                                          : const Image(
                                              image: AssetImage(
                                                  "assets/images/shakil_upi_scaner.jpg")),
                                    ),
                                  ),
                                ),
                                const Text("My Stamp",),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.date_range,
                                color: Colors.green, size: 18),
                          ),
                          SizedBox(width: 5),
                          Text("Generated By UdaanBiz",
                              style: TextStyle(fontSize: 12)),
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                AssetImage("assets/images/udaan_biz_logo.png"),
                          ),
                          SizedBox(width: 5),
                          Text("UdaanBiz", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: AppThem.appBgColor,
                        ),
                        // ग्राहक
                        child: Padding(padding: const EdgeInsetsGeometry.only(left: 10,right: 10,top: 5,bottom: 5),
                        child:Text("प्रिय ग्राहक ${widget.name}, कृपया सुनिश्चित करें कि भुगतान 10 दिनों के भीतर कर दिया जाए, ताकि क्रेडिट सेवाएं बिना किसी रुकावट के जारी रह सकें। आपका सहयोग अपेक्षित है। धन्यवाद!",style: TextStyle(color: AppThem.appTextColor),),),),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
