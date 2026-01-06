import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../RazorPayModels/order_request_model.dart';
import '../RazorPayModels/razor_pay_api_model.dart';
class RazorPayProvider with ChangeNotifier{
  //var baseUrl = "https://api.razorpay.com/v1/orders";
  static const apiUrl  ="https://api.razorpay.com/v1/orders";
  List<RazorPayApiModel> productList = [];


  Future<List<RazorPayApiModel>> createOrder(double amount)async{
    String basicAuth = 'Basic ${base64.encode(utf8.encode('rzp_test_nie6nwGGJFgejv:NnVvOiJW3mYR7UekdRlCCjHz'))}';
    try{
      var response = await http.post(Uri.parse(apiUrl),
          body:jsonEncode({
            "amount": amount,
            "currency": "INR",
            "receipt": "Receipt no. 1",
            "notes": {
              "notes_key_1": "Tea, Earl Grey, Hot",
              "notes_key_2": "Tea, Earl Grey… decaf."
            }
          }),
          headers: {
            "Authorization": basicAuth
          });
      if(response.statusCode == 200){
        List<dynamic> convertData = json.decode(response.body);
        productList = convertData.map((e) => RazorPayApiModel.fromJson(e)).toList();
        Fluttertoast.showToast(msg: "Payment success ");
        return productList;
      }
      else {
        Fluttertoast.showToast(msg: "show data Failed ");
        return productList;
      }

    }catch(e){
      Fluttertoast.showToast(msg: "Error $e");
      return productList;
    }
  }
  Future<String> createNewOrder(double amount)async{
    String basicAuth = 'Basic ${base64.encode(utf8.encode('rzp_test_nie6nwGGJFgejv:NnVvOiJW3mYR7UekdRlCCjHz'))}';
    var response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(OrderRequestModel.getOrderRequestBody(amount)),
        headers: {
          "Authorization": basicAuth
        });
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "Payment success ");
      return data['id'].toString();
    }
    else {
      Fluttertoast.showToast(msg: "Failed to create Data");
      throw Exception("Failed to create Data");
    }

  }

}