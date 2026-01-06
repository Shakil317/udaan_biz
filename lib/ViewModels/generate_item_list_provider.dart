import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class GenerateItemListProvider with ChangeNotifier{
  final GlobalKey shareBillPdfKey = GlobalKey();
  final List<String> units = [
    'Kg (Kilogram)',
    'L (Liter)',
    'Pc (Piece)',
    'Pkt (Packet)',
    'M (Meter)',
    'Qt (Quintal)',
    'Ton (Tonne)',
    'g (Gram)',
    'ml (Milliliter)',
    'Dz (Dozen)',
    'Box (Box)',
    'Bag (Bag)',
    'Bdl (Bundle)',
    'Pair (Pair)',
    'cm (Centimeter)',
    'ft (Foot)',
    'in (Inch)',
    'sqft (Square Feet)',
    'sqm (Square Meter)',
  ];
  TextEditingController dateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  TextEditingController timeController = TextEditingController(
    text: DateFormat('hh:mm a').format(DateTime.now()),
  );
  TextEditingController custemerNameCont = TextEditingController();
  TextEditingController holidayNameCont = TextEditingController();
  TextEditingController gstNumCont = TextEditingController();

  final List<TextEditingController> nameCtr =
  List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> qtyCtr =
  List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> rateCtr =
  List.generate(15, (_) => TextEditingController());
  final List<String> selectedUnit = List.generate(19, (_) => 'Kg (Kilogram)');

  final List<double> amount = List.generate(15, (_) => 0);

  int visibleProducts = 1;

  double get totalAmount =>
      amount.take(visibleProducts).fold(0, (a, b) => a + b);

  bool isProductFilled(int index) {
    return nameCtr[index].text.isNotEmpty &&
        qtyCtr[index].text.isNotEmpty &&
        rateCtr[index].text.isNotEmpty;
  }

  void calculate(int index) {
    double qty = double.tryParse(qtyCtr[index].text) ?? 0;
    double rate = double.tryParse(rateCtr[index].text) ?? 0;

      amount[index] = qty * rate;

      if (isProductFilled(index) && visibleProducts < 15) {
        visibleProducts = index + 2;
      }
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
  Future<void> saveAndSharePDF() async {
    try {
      final boundary = shareBillPdfKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat:
          const PdfPageFormat(8 * PdfPageFormat.cm, 13 * PdfPageFormat.cm),
          build: (context) {
            return pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/product_item_list_from_UdaanBiz.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Product Item Bill from UdaanBiz',
      );
    } catch (e) {
      debugPrint("PDF Error: $e");
    }
  }


}