import 'package:flutter/material.dart';
import 'package:mycalculator/screens/status_view_screen.dart';
import 'card_status_screen.dart';

class StatusViewHome extends StatelessWidget {
  const StatusViewHome({super.key});
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              overlayColor: WidgetStatePropertyAll(Colors.black45.withOpacity(0.1)),
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: false,
              dividerColor: Colors.black45.withOpacity(0.1),
              labelColor: Colors.black54,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.transparent,
              tabs: const [
                Tab(text: "Video/Image Status"),
                Tab(text: "Cards Status"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  StatusViewScreen(),
                  CardStatusScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}