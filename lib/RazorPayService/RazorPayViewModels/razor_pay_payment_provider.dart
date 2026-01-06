import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycalculator/RazorPayService/RazorPayViewModels/razor_pay_api_provider.dart';
import 'package:mycalculator/ViewModels/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPaymentProvider with ChangeNotifier{
  late Razorpay _razorpay;

  void setScreen(BuildContext context, shareKeys){
    var data = Provider.of<CardProvider>(context,listen: false);
  }

  //  {required VoidCallback onPaymentSuccess}


  void addPaymentListener(BuildContext context, GlobalKey cardKey) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse success) async {
      await Future.delayed(const Duration(milliseconds: 400));

      if (cardKey.currentContext != null) {
        await Provider.of<CardProvider>(context, listen: false).shareCard(cardKey);
      } else {
        Fluttertoast.showToast(msg: "Unable to access card for sharing.");
      }
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse error) {
      Fluttertoast.showToast(msg: "Payment Failed ❌ ${error.message}");
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse wallet) {
      Fluttertoast.showToast(msg: "External Wallet: ${wallet.walletName}");
    });
  }


  // void addPaymentListener(BuildContext context,GlobalKey cardKey){
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse success){
  //     Fluttertoast.showToast(gravity: ToastGravity.CENTER,msg: "Payment Success ${success.paymentId} :${success.signature}",toastLength: Toast.LENGTH_LONG,);
  //     Provider.of<CardProvider>(context, listen: false).saveCardAsPdf(cardKey);
  //
  //
  //   });
  //
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse error){
  //     Fluttertoast.showToast(msg: "Failed ${error.message}");
  //   });
  //
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (PaymentFailureResponse failed){
  //     Fluttertoast.showToast(msg: "Failed ${failed.message}");
  //   });
  //
  // }

  void handlePaymentSuccess(BuildContext context, {required VoidCallback onPaymentSuccess}) async{
    double amount = 5.0 * 100;
    var orderId = await RazorPayProvider().createNewOrder(amount);
    var options = {
      'key': 'rzp_test_nie6nwGGJFgejv',
      'amount': amount,
      'name': 'UdaanBiz',
      'order_id': orderId,
      'description': 'Fine T-Shirt',
      'timeout': 60,
      'prefill': {
        'contact': '6206731127',
        'email': 'ansarishakil.ismail@gmail.com'
      }
    };
    _razorpay.open(options);

  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

}