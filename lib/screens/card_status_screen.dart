import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycalculator/Utils/about_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../RazorPayService/RazorPayViewModels/razor_pay_payment_provider.dart';
import '../Utils/app_them.dart';
import '../ViewModels/card_provider.dart';
import '../ViewModels/transition_history_provider.dart';
import '../ViewModels/user_profile_provider.dart';

class CardStatusScreen extends StatefulWidget {
  final int? id;
  final String? name;
  final String? usersData;

  const CardStatusScreen({super.key, this.id, this.usersData, this.name});

  @override
  State<CardStatusScreen> createState() => _CardStatusScreenState();
}

class _CardStatusScreenState extends State<CardStatusScreen> {
  var user = FirebaseAuth.instance.currentUser;
  late TransitionHistoryProvider creditProvider;
  late UserProfileProvider profileProvider;
  late PaymentPaymentProvider provider;

  @override
  void initState() {
    provider = Provider.of<PaymentPaymentProvider>(context,listen: false);
    provider.addPaymentListener(context,GlobalKey());
    AboutApp.disableScreenshot();
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
    var cardProvider = Provider.of<CardProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer<UserProfileProvider>(
                builder: (context, value, child) {
                  if (value.userProfile.isEmpty) {
                    return  const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                  final profile = value.userProfile[0];

                  final List<Map<String, dynamic>> cardData = [
                    {
                      "about":
                          "हमारे यहाँ शुद्धता की गारंटी के साथ दूध, दही, देशी घी, शहद और समस्त राशन सामग्री आपको उचित दामों पर उपलब्ध है!",
                      "colors": [Colors.red, Colors.orange],
                      "shareKey": cardProvider.shareKeys[0],
                    },
                    {
                      "about":
                          "हमारे यहाँ सभी प्रकार की दवाइयाँ - सस्ती और भरोसेमंद कीमत पर उपलब्ध हैं!",
                      "colors": [Colors.green, Colors.red],
                      "shareKey": cardProvider.shareKeys[1],
                    },
                    {
                      "about":
                          "हमारे यहाँ ताज़ी और शुद्ध सब्ज़ियाँ उचित दामों पर उपलब्ध हैं। शादी, विवाह या किसी भी शुभ अवसर पर हमें सेवा का अवसर अवश्य दें!",
                      "colors": [Colors.redAccent, Colors.black26],
                      "shareKey": cardProvider.shareKeys[2],
                    },
                    {
                      "about":
                          "हमारे यहाँ सभी प्रकार की दवाइयाँ एलोपैथिक, होम्योपैथिक एवं आयुर्वेदिक-सस्ती और भरोसेमंद कीमत पर उपलब्ध हैं!",
                      "colors": [Colors.blueAccent, Colors.black54],
                      "shareKey": cardProvider.shareKeys[3],
                    },
                    {
                      "about":
                          "हमारे यहाँ  ताज़े फल जैसे आम, केला, सेब, अंगूर, संतरा उचित मूल्य पर मिलते हैं!",
                      "colors": [Colors.pink, Colors.purple],
                      "shareKey": cardProvider.shareKeys[4],
                    },
                    {
                      "about":
                          "हर दिन ताज़गी और विश्वास के साथ! हमारी ताज़ी सब्ज़ियाँ शादी, विवाह या किसी भी शुभ अवसर के लिए सबसे उपयुक्त हैं!",
                      "colors": [Colors.teal, Colors.teal],
                      "shareKey": cardProvider.shareKeys[5],
                    },
                    {
                      "about":
                          "ग्राहक की संतुष्टि ही हमारी सबसे बड़ी सफलता है! यह दुकान किसी भी शुभ अवसर के लिए सबसे उपयुक्त हैं!",
                      "colors": [Colors.orange, Colors.green],
                      "shareKey": cardProvider.shareKeys[6],
                    },
                    {
                      "about":
                          "ग्राहक की संतुष्टि ही हमारी सबसे बड़ी सफलता है! हमारे यहां किसी भी शुभ अवसर के लिए सबसे उपयुक्त हैं!",
                      "colors": [Colors.green, Colors.orange],
                      "shareKey": cardProvider.shareKeys[7],
                    },
                    {
                      "about":
                          "आपके भरोसे का सही ठिकाना! राशन से लेकर रोज़मर्रा की ज़रूरत – सब कुछ एक ही छत के नीचे!",
                      "colors": [Colors.black, Colors.black54],
                      "shareKey": cardProvider.shareKeys[8],
                    },
                    {
                      "about": "आपके भरोसे का सही ठिकाना – राशन, किराना, ताज़ी सब्ज़ियाँ और रोज़मर्रा की हर ज़रूरत अब एक ही स्थान पर उपलब्ध!",
                      "colors": [Colors.blue, Colors.purple],
                      "shareKey": cardProvider.shareKeys[9],
                    },
                    {
                      "about": "हर जरूरत की चीज़ – चाहे घर की हो या रसोई की – अब शुद्धता और उचित मूल्य के साथ एक ही छत के नीचे!!",
                      "colors": [Colors.blue, Colors.purple],
                      "shareKey": cardProvider.shareKeys[10],
                    },
                    {
                      "about": "भरोसे, गुणवत्ता और सस्ती कीमत का संगम – एक ऐसा नाम जिस पर पूरा परिवार भरोसा कर सके!",
                      "colors": [Colors.blue, Colors.purple],
                      "shareKey": cardProvider.shareKeys[11],
                    },
                    {
                      "about":
                          "ग्राहकों की संतुष्टि ही हमारी सबसे बड़ी कमाई है – यही सोच बनाती है हमें सबसे खास!",
                      "colors": [Colors.red, Colors.orange],
                      "shareKey": cardProvider.shareKeys[12],
                    },
                    {
                      "about":
                          "हमसे जुड़िए – और अनुभव कीजिए एक ऐसी सेवा, जो सिर्फ व्यापार नहीं, एक रिश्ते को निभाती है!",
                      "colors": [Colors.green, Colors.red],
                      "shareKey": cardProvider.shareKeys[13],
                    },
                    {
                      "about":
                          "जो चाहिए, जब चाहिए – हम हमेशा तैयार हैं आपकी सेवा में, भरोसे और मुस्कान के साथ!",
                      "colors": [Colors.blue, Colors.purple],
                      "shareKey": cardProvider.shareKeys[14],
                    },
                    {
                      "about":
                          "हमसे जुड़िए – और अनुभव कीजिए एक ऐसी सेवा, जो सिर्फ व्यापार नहीं, एक रिश्ते को निभाती है!",
                      "colors": [Colors.black, Colors.black12],
                      "shareKey": cardProvider.shareKeys[15],
                    },
                    {
                      "about":
                          "शुद्धता का वादा, उचित दाम की गारंटी – आपके विश्वास के साथ बढ़ते कदम!",
                      "colors": [Colors.blueGrey, Colors.purple],
                      "shareKey": cardProvider.shareKeys[16],
                    },
                    {
                      "about":
                          "विश्वास, सुविधा और गुणवत्ता – ये तीनों अब एक ही छत के नीचे आपके अपने स्टोर में!",
                      "colors": [Colors.purple, Colors.purpleAccent],
                      "shareKey": cardProvider.shareKeys[17],
                    },
                    {
                      "about":
                          "अब न भागदौड़, न अलग-अलग जगहों पर जाना – हर ज़रूरत का सामान मिलेगा हमारे यहाँ, वो भी भरोसे और प्यार के साथ!",
                      "colors": [Colors.blue, Colors.greenAccent],
                      "shareKey": cardProvider.shareKeys[18],
                    },
                    {
                      "about":
                          "सभी घरेलू ज़रूरतों का समाधान – दूध, दही, घी, फल, सब्ज़ी और राशन – सब कुछ एक ही जगह पर!",
                      "colors": [Colors.yellow, Colors.blue],
                      "shareKey": cardProvider.shareKeys[19],
                    },
                    {
                      "about":
                          "भरोसे, गुणवत्ता और सस्ती कीमत का संगम – एक ऐसा नाम जिस पर पूरा परिवार भरोसा कर सके!",
                      "colors": [Colors.green, Colors.black],
                      "shareKey": cardProvider.shareKeys[20],
                    },

                  //
                  //   {
                  //     "about": "हर ग्राहक हमारे लिए खास है – आपका विश्वास ही हमारी पहचान है!",
                  //     "colors": [Colors.green, Colors.blue],
                  //     "shareKey": cardProvider.shareKeys[21],
                  //   },
                  //
                  //   {
                  //     "about": "काम ऐसा जो दिल जीत ले, और सेवा ऐसी जो याद रह जाए!",
                  //     "colors": [Colors.blue, Colors.cyan],
                  //     "shareKey": cardProvider.shareKeys[22],
                  //   },
                  //
                  //   {
                  //     "about": "विश्वास की मजबूत नींव पर खड़ी आपकी अपनी पहचान!",
                  //     "colors": [Colors.deepPurple, Colors.blue],
                  //     "shareKey": cardProvider.shareKeys[23],
                  //   },
                  //
                  //   {
                  //     "about": "काम भी ज़बरदस्त, अंदाज़ भी शानदार – एक बार आएँगे तो बार-बार याद करेंगे!",
                  //     "colors": [Colors.yellow, Colors.orange],
                  //     "shareKey": cardProvider.shareKeys[24],
                  //   },
                  //
                  //   {
                  //     "about": "यहाँ सिर्फ सामान नहीं, मुस्कान भी फ्री मिलती है ",
                  //     "colors": [Colors.pink, Colors.orange],
                  //     "shareKey": cardProvider.shareKeys[25],
                  //   },
                  //
                  //   {
                  //     "about": "दुकान छोटी हो या बड़ी – दिल हमेशा बड़ा मिलता है यहाँ!",
                  //     "colors": [Colors.green, Colors.teal],
                  //     "shareKey": cardProvider.shareKeys[26],
                  //   },
                  //
                  //   {
                  //     "about": "रेट कम, क्वालिटी दमदार – बाकी सब बेकार ",
                  //     "colors": [Colors.blue, Colors.red],
                  //     "shareKey": cardProvider.shareKeys[27],
                  //   },
                  //
                  //   {
                  //     "about": "जो एक बार जुड़ा, वो बार-बार मुड़ा ",
                  //     "colors": [Colors.purple, Colors.orange],
                  //     "shareKey": cardProvider.shareKeys[28],
                  //   },
                  //
                  //   {
                  //     "about": "जनसेवा ही हमारा धर्म, और आपका विश्वास हमारी ताकत!",
                  //     "colors": [Colors.orange, Colors.green],
                  //     "shareKey": cardProvider.shareKeys[29],
                  //   },
                  //
                  //   {
                  //     "about": "हर आवाज़ की कदर, हर इंसान का सम्मान!",
                  //     "colors": [Colors.blue, Colors.white],
                  //     "shareKey": cardProvider.shareKeys[30],
                  //   },
                  //
                  //   {
                  //     "about": "विकास, विश्वास और जनता के साथ का संकल्प!",
                  //     "colors": [Colors.green, Colors.orange],
                  //     "shareKey": cardProvider.shareKeys[31],
                  //   },
                  //
                  //   {
                  //     "about": "जनता का साथ, सेवा का विश्वास – यही है हमारा प्रयास!",
                  //     "colors": [Colors.red, Colors.green],
                  //     "shareKey": cardProvider.shareKeys[32],
                  //   },
                  //
                  //   {
                  //     "about": "आपका भरोसा ही हमारी सबसे बड़ी जीत है!",
                  //     "colors": [Colors.blue, Colors.orange],
                  //     "shareKey": cardProvider.shareKeys[33],
                  //   },
                  //
                  //   {
                  //     "about": "हर घर की आवाज़, हर दिल का विश्वास!",
                  //     "colors": [Colors.purple, Colors.red],
                  //     "shareKey": cardProvider.shareKeys[34],
                  //   },
                  //
                  //   {
                  //     "about": "बेहतर सेवा, बेहतर गुणवत्ता और बेहतर भरोसा – सब कुछ एक साथ!",
                  //     "colors": [Colors.cyan, Colors.blue],
                  //     "shareKey": cardProvider.shareKeys[35],
                  //   },
                  //
                  //   {
                  //     "about": "हर दिन बेहतर बनने की कोशिश – सिर्फ आपके लिए!",
                  //     "colors": [Colors.teal, Colors.green],
                  //     "shareKey": cardProvider.shareKeys[36],
                  //   },
                  //
                  //   {
                  //     "about": "जहाँ गुणवत्ता और भरोसा कभी समझौता नहीं करते!",
                  //     "colors": [Colors.indigo, Colors.deepPurple],
                  //     "shareKey": cardProvider.shareKeys[37],
                  //   },
                  //
                  //   {
                  //     "about": "आपकी खुशी ही हमारी सफलता की असली पहचान है!",
                  //     "colors": [Colors.purpleAccent, Colors.deepOrange],
                  //     "shareKey": cardProvider.shareKeys[38],
                  //   },
                  //
                  //   {
                  //     "about": "नाम ही काफी है – भरोसे और सेवा की पहचान!",
                  //     "colors": [Colors.black45, Colors.yellow],
                  //     "shareKey": cardProvider.shareKeys[39],
                  //   },
                  ];
                  return ListView.builder(
                    itemCount: cardData.length,
                    itemBuilder: (context, index) {
                      final item = cardData[index];
                      return buildProfileCard(
                          shareKey: item["shareKey"],
                          startColor: item["colors"][0],
                          endColor: item["colors"][1],
                          profile: profile,
                          actionButton: () {
                             cardProvider.shareCard(item["shareKey"]);

                             // provider.handlePaymentSuccess(
                             //   context,
                             //   onPaymentSuccess: () async {
                             //     await Future.delayed(const Duration(milliseconds: 400));
                             //     Fluttertoast.showToast(msg: "Preparing your card...");
                             //     cardProvider.shareCard(item["shareKey"]);
                             //   },
                             // );
                          },
                          about: item["about"],
                        );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatText(String text, int maxCharsPerLine) {
    List<String> lines = [];
    for (int i = 0; i < text.length; i += maxCharsPerLine) {
      int end = (i + maxCharsPerLine < text.length)
          ? i + maxCharsPerLine
          : text.length;
      lines.add(text.substring(i, end));
    }
    return lines.join('\n');
  }

  Widget buildProfileCard({
    required GlobalKey shareKey,
    required Color startColor,
    required String about,
    required Color endColor,
    required dynamic profile,
    required VoidCallback actionButton,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 5),
      child:
      Column(
        children: [
          RepaintBoundary(
            key: shareKey,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3 - 40,
                  width: MediaQuery.of(context).size.width * 1 - 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: [startColor, endColor]),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: [startColor, endColor]),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Profile Image (left)
                Positioned(
                  left: 12.0,
                  top: 5,
                  child: Container(
                    height: 100,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: profile.profileImage != null
                          ? Image.file(File(profile.profileImage!),
                              fit: BoxFit.cover)
                          : Image.asset("assets/images/udaan_biz_logo.png",
                              fit: BoxFit.cover),
                    ),
                  ),
                ),

                /// प्रो० text
                const Positioned(
                  left: 110.0,
                  top: 10,
                  child: Text(
                    "प्रो०:-",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// Phone Number
                Positioned(
                  left: 170.0,
                  top: 10,
                  child: Text(
                    "📞  ${profile.phone}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// Name
                Positioned(
                  left: 105.0,
                  top: 40,
                  child: Text(
                    formatText("${profile.shopName}", 25),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Positioned(
                  left: 10.0,
                  top: 110,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6 +
                        8, // adjust according to your layout
                    child: Text(
                      about,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      // Set maximum lines if needed
                      overflow: TextOverflow.ellipsis,
                      // Shows "..." if too long
                      softWrap: true,
                    ),
                  ),
                ),

                /// Address
                Positioned(
                  left: 15.0,
                  top: 165,
                  child: Text(
                    formatText("पता:- ${profile.bankInfo}", 42),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// Khatabook Image (right)
                Positioned(
                  left: 235.0,
                  top: 90,
                  right: 5.0,
                  child: Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: profile.uploadStamp != null
                          ? Image.file(File(profile.uploadStamp!),
                              fit: BoxFit.cover)
                          : Image.asset("assets/images/udaan_biz_logo.png",
                              fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: SizedBox(
              width: 320,
              child: ElevatedButton.icon(
                onPressed: () async{
                   await Permission.storage.request();
                   actionButton();
                // // provider.handlePaymentSuccess(context);
                //   actionButton();

                   // provider.handlePaymentSuccess(
                   //   context,
                   //   onPaymentSuccess: () async {
                   //     await Future.delayed(const Duration(milliseconds: 400));
                   //     Fluttertoast.showToast(msg: "Preparing your card...");
                   //    actionButton();
                   //   },
                   // );
                },
                icon: const Icon(Icons.download, color: Colors.white, size: 18),
                label:
                    const Text("Download And Share", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThem.appBgColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
