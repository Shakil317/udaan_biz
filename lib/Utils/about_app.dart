import 'package:flutter/cupertino.dart';
import 'package:no_screenshot/no_screenshot.dart';

class AboutApp{
  static  final _noScreenshot = NoScreenshot.instance;
  static void disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }
 static void enableScreenshot() async {
    bool result = await _noScreenshot.screenshotOn();
    debugPrint('Enable Screenshot: $result');
  }
}