import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycalculator/Utils/app_dialog.dart';
import 'package:mycalculator/screens/user_screens.dart';
import 'package:provider/provider.dart';
import '../Utils/app_them.dart';
import '../ViewModels/advanced_calculater_provider.dart';
import 'calculator_screen.dart';

class AdvancedCalculateScreen extends StatefulWidget {
  const AdvancedCalculateScreen({super.key});

  @override
  State<AdvancedCalculateScreen> createState() => _AdvancedCalculateScreenState();
}

class _AdvancedCalculateScreenState extends State<AdvancedCalculateScreen> {

  final LocalAuthentication auth = LocalAuthentication();

  void checkAuth()async{
    bool isAvailable;
    isAvailable = await auth.canCheckBiometrics;
    Fluttertoast.showToast(msg: "is Available");

    if(isAvailable){
      bool result = await auth.authenticate(
        localizedReason: "Scan Your Finger Print to Proceed",
        options:const AuthenticationOptions(biometricOnly: true),
      );
      if(result){
      AppDialog.navigatePage(context, const UserScreens());
      }else{
        Fluttertoast.showToast(msg: "Permission Denied");
      }

    }else{
      Fluttertoast.showToast(msg: "No Biometric sensor detected");
    }

  }
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var calculatorProvider2 = Provider.of<AdvancedCalculatorProvider>(context);
    return Scaffold(
      backgroundColor: AppThem.appBgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalculateScreen(),
                                  ),
                                );
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                              },
                              icon: const Icon(
                                Icons.calculate,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                checkAuth();
                              },
                              icon: const Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.9,
                            height: 50,
                            child:   Padding(
                              padding:  const EdgeInsets.all(8.0),
                              child: Text(
                                calculatorProvider2.baseInput,
                                maxLines: 2,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:
                          Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              height: 50,
                              padding:  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              child:  Text(
                                calculatorProvider2.baseResult,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        )
                      ],
                    ),

                  ],
                ),
              ],
            ),
         const Divider(
            color: Colors.white70,
            thickness: 2,
          ),
            Expanded(
              child: Padding(
                padding:  const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: calculatorProvider2.buttonList.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisExtent:34,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return customButton(calculatorProvider2.buttonList[index],context);
                  },
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }

  Widget customButton(String text, BuildContext context) {
    var calculatorProvider2 = Provider.of<AdvancedCalculatorProvider>(context);
    return InkWell(
      splashColor: const Color(0xFF1d2630),
      onTap: () {
        calculatorProvider2.userHandleButton(text, context);
      },
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: calculatorProvider2.getButtonColor(text, context),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
           text,
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: calculatorProvider2.getButtonTextColor(text, context),
            ),
          ),
        ),
      ),
    );
  }
}
