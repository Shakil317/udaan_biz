import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Utils/app_them.dart';
import '../ViewModels/calculate_provider.dart';
import 'advanced_calculate_screen.dart';
class CalculateScreen extends StatelessWidget {
  const CalculateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var calculatorProvider = Provider.of<CalculateProvider>(context);
    return Scaffold(
      backgroundColor:AppThem.appBgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3.35,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0, right: 5),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AdvancedCalculateScreen(),
                                    ));
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.squareRootVariable,
                                size: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, right: 10),
                            child: IconButton(
                                onPressed: () {
                                 calculatorProvider.checkLocalAuth(context);
                                },
                                icon: const Icon(
                                  Icons.history,
                                  size: 20,
                                )),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.bottomRight,
                        child: SingleChildScrollView(
                          controller: calculatorProvider.scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  calculatorProvider.userInput,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 2, right: 2),
                        alignment: Alignment.bottomRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      calculatorProvider.result,
                                      style: TextStyle(
                                          fontSize: calculatorProvider.result.length > 12 ? 35 : 48,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             const Divider(
              color: Colors.white70,
              thickness:4 ,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            calculatorProvider.handleButton(
                                "backspace", context);
                          },
                          icon: const Icon(
                            Icons.backspace,
                            color: Colors.red,
                            size: 32,
                          )),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 0.0,left: 5.0,right: 5.0,bottom: 5.0),
                child: GridView.builder(
                  itemCount: calculatorProvider.buttonList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return customButton(
                        calculatorProvider.buttonList[index], context);
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
    var calculatorProvider = Provider.of<CalculateProvider>(context);
    return InkWell(
      splashColor: const Color(0xFF1d2630),
      onTap: () {
        calculatorProvider.handleButton(text, context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: calculatorProvider.getBgColor(text, context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white38.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: calculatorProvider.getColor(text, context)),
          ),
        ),
      ),
    );
  }
}
