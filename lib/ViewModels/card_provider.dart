import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class CardProvider with ChangeNotifier {
  final List<GlobalKey> shareKeys = List.generate(21, (index) => GlobalKey());
  // final List<List<Color>> _colorPairs = [
  //   [Colors.black, Colors.orange],
  //   [Colors.green, Colors.red],
  //   [Colors.blue, Colors.purple],
  //   [Colors.teal, Colors.indigo],
  //   [Colors.deepOrange, Colors.amber],
  //   [Colors.brown, Colors.cyan],
  //   [Colors.black, Colors.orange],
  //   [Colors.green, Colors.red],
  //   [Colors.blue, Colors.purple],
  //   [Colors.teal, Colors.indigo],
  //   [Colors.deepOrange, Colors.amber],
  //   [Colors.brown, Colors.cyan],
  //   [Colors.black, Colors.orange],
  //   [Colors.green, Colors.red],
  //   [Colors.blue, Colors.purple],
  //   [Colors.teal, Colors.indigo],
  //   [Colors.deepOrange, Colors.amber],
  //   [Colors.brown, Colors.cyan],
  //   [Colors.teal, Colors.indigo],
  //   [Colors.deepOrange, Colors.amber],
  //   [Colors.brown, Colors.cyan],
  // ];
  // final List<List<String>> _aboutTitle = [
  //   [
  //     "हमारे यहाँ शुद्धता की गारंटी के साथ दूध, दही, देशी घी, शहद और समस्त राशन सामग्री आपको उचित दामों पर उपलब्ध है!"
  //   ],
  //   [
  //     "हमारे यहाँ सभी प्रकार की दवाइयाँ - सस्ती और भरोसेमंद कीमत पर उपलब्ध हैं!"
  //   ],
  //   [
  //     "हमारे यहाँ ताज़ी और शुद्ध सब्ज़ियाँ उचित दामों पर उपलब्ध हैं। शादी, विवाह या किसी भी शुभ अवसर पर हमें सेवा का अवसर अवश्य दें!"
  //   ],
  //   [
  //     "हमारे यहाँ सभी प्रकार की दवाइयाँ एलोपैथिक, होम्योपैथिक एवं आयुर्वेदिक-सस्ती और भरोसेमंद कीमत पर उपलब्ध हैं!"
  //   ],
  //   [
  //     "हमारे यहाँ  ताज़े फल जैसे आम, केला, सेब, अंगूर, संतरा उचित मूल्य पर मिलते हैं!"
  //   ],
  //   [
  //     "हर दिन ताज़गी और विश्वास के साथ! हमारी ताज़ी सब्ज़ियाँ शादी, विवाह या किसी भी शुभ अवसर के लिए सबसे उपयुक्त हैं!"
  //   ],
  //   [
  //     "ग्राहक की संतुष्टि ही हमारी सबसे बड़ी सफलता है! यह दुकान किसी भी शुभ अवसर के लिए सबसे उपयुक्त हैं!"
  //   ],
  //   [
  //     "ग्राहक की संतुष्टि ही हमारी सबसे बड़ी सफलता है! हमारे यहां किसी भी शुभ अवसर के लिए सबसे उपयुक्त हैं!"
  //   ],
  //   [
  //     "आपके भरोसे का सही ठिकाना! राशन से लेकर रोज़मर्रा की ज़रूरत – सब कुछ एक ही छत के नीचे!"
  //   ],
  //   [
  //     "आपके भरोसे का सही ठिकाना – राशन, किराना, ताज़ी सब्ज़ियाँ और रोज़मर्रा की हर ज़रूरत अब एक ही स्थान पर उपलब्ध!"
  //   ],
  //   [
  //     "हर जरूरत की चीज़ – चाहे घर की हो या रसोई की – अब शुद्धता और उचित मूल्य के साथ एक ही छत के नीचे!"
  //   ],
  //   [
  //     "भरोसे, गुणवत्ता और सस्ती कीमत का संगम – एक ऐसा नाम जिस पर पूरा परिवार भरोसा कर सके"
  //   ],
  //   [
  //     "सभी घरेलू ज़रूरतों का समाधान – दूध, दही, घी, फल, सब्ज़ी और राशन – सब कुछ एक ही जगह पर!"
  //   ],
  //   [
  //     "अब न भागदौड़, न अलग-अलग जगहों पर जाना – हर ज़रूरत का सामान मिलेगा हमारे यहाँ, वो भी भरोसे और प्यार के साथ!"
  //   ],
  //   [
  //     "विश्वास, सुविधा और गुणवत्ता – ये तीनों अब एक ही छत के नीचे आपके अपने स्टोर में!"
  //   ],
  //   [
  //     "शुद्धता का वादा, उचित दाम की गारंटी – आपके विश्वास के साथ बढ़ते कदम!"
  //   ],
  //   [
  //     "हमसे जुड़िए – और अनुभव कीजिए एक ऐसी सेवा, जो सिर्फ व्यापार नहीं, एक रिश्ते को निभाती है!"
  //   ],
  //   [
  //     "जो चाहिए, जब चाहिए – हम हमेशा तैयार हैं आपकी सेवा में, भरोसे और मुस्कान के साथ!"
  //   ],
  //   [
  //     "हमसे जुड़िए – और अनुभव कीजिए एक ऐसी सेवा, जो सिर्फ व्यापार नहीं, एक रिश्ते को निभाती है!"
  //   ],
  //   [
  //     "ग्राहकों की संतुष्टि ही हमारी सबसे बड़ी कमाई है – यही सोच बनाती है हमें सबसे खास!"
  //   ],
  //   ["किसी भी शुभ अवसर पर एक बार सेवा का मौका अवश्य दें!"],
  // ];
  Future<void> shareCard(GlobalKey cardKey) async {
    try {
      RenderRepaintBoundary boundary =
      cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat:
          const PdfPageFormat(5.0 * PdfPageFormat.cm, 3.0 * PdfPageFormat.cm),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/Share_Card.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)], text: 'Share Card PDF from UdaanBiz',);
      Fluttertoast.showToast(msg: "Share Card Success");
    } catch (e) {
      print("Error creating or sharing PDF: $e");
    }
  }

  Future<void> saveCardAsPdf(GlobalKey cardKey) async {
    try {
      RenderRepaintBoundary boundary =
      cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(5.0 * PdfPageFormat.cm, 3.0 * PdfPageFormat.cm),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save your card as PDF',
        fileName: 'UdaanBiz_Card.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (outputFile == null) return;
      final file = File(outputFile);
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(cardKey.currentContext!).showSnackBar(
        SnackBar(content: Text("PDF saved to $outputFile")),
      );
    } catch (e) {
      print("Error saving PDF: $e");
      ScaffoldMessenger.of(cardKey.currentContext!).showSnackBar(
        const SnackBar(content: Text("Failed to save PDF.")),
      );
    }
  }

}
