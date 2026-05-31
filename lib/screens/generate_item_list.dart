import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycalculator/screens/item_list_screen.dart';
import 'package:provider/provider.dart';
import '../RazorPayService/RazorPayViewModels/razor_pay_payment_provider.dart';
import '../Utils/app_them.dart';
import '../ViewModels/generate_item_list_provider.dart';

class GenerateItemListScreen extends StatefulWidget {
  const GenerateItemListScreen({super.key});

  @override
  State<GenerateItemListScreen> createState() => _GenerateItemListScreenState();
}

class _GenerateItemListScreenState extends State<GenerateItemListScreen> {
  @override
  Widget build(BuildContext context) {
    var payment = Provider.of<PaymentPaymentProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppThem.appBgColor,
          icon:Icon(Icons.open_with,color: Colors.white,),
          onPressed: () {
            openGenerateBillBottomSheet(context);
          
        }, label: Text("Billing Item",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
      ),
    );
  }

  void openGenerateBillBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const GenerateBillBottomSheet(),
    );
  }
}

class GenerateBillBottomSheet extends StatefulWidget {
  const GenerateBillBottomSheet({super.key});

  @override
  State<GenerateBillBottomSheet> createState() =>
      _GenerateBillBottomSheetState();
}

class _GenerateBillBottomSheetState extends State<GenerateBillBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppThem.appBgColor,),
        body: Consumer<GenerateItemListProvider>(
          builder: (context, value, child) {
            return Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom*0.05,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofillHints: value.selectedUnit,
                    controller: value.custemerNameCont,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: AppThem.appBgColor),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: "Enter Custemer Name",
                      labelStyle: TextStyle(color: AppThem.appBgColor),
                      prefixIcon: Icon(Icons.person, color: AppThem.appBgColor),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       SizedBox(
                        width: 160,
                        height: 45,
                        child: TextField(
                          controller: value.holidayNameCont,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(color: AppThem.appBgColor),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: "Holiday Name",
                            hintStyle: TextStyle(color: AppThem.appBgColor),
                            labelStyle: TextStyle(color: AppThem.appBgColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        height: 45,
                        child: TextField(
                          controller: value.gstNumCont,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: AppThem.appBgColor),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: "Enter GST Number",
                            hintStyle: TextStyle(color: AppThem.appBgColor),
                            labelStyle: TextStyle(color: AppThem.appBgColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 45,
                        child: TextField(
                          controller:value.dateController,
                          keyboardType: TextInputType.datetime,
                          style: const TextStyle(color: AppThem.appBgColor),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: "Current Date",
                            hintText: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                            hintStyle: const TextStyle(color: AppThem.appBgColor),
                            labelStyle: const TextStyle(color: AppThem.appBgColor),
                            prefixIcon: IconButton(
                              onPressed: () {
                                value.selectedDate(context);
                              },
                              icon: const Icon(
                                Icons.date_range,
                                color: AppThem.appBgColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 45,
                        child: TextField(
                          controller: value.timeController,
                          keyboardType: TextInputType.datetime,
                          style: const TextStyle(color: AppThem.appBgColor),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: "Current Time",
                            hintText: DateFormat('hh:mm a').format(DateTime.now()),
                            hintStyle: const TextStyle(color: AppThem.appBgColor),
                            labelStyle: const TextStyle(color: AppThem.appBgColor),
                            prefixIcon: IconButton(
                              onPressed: () {
                                value.selectedTime(context);
                              },
                              icon: const Icon(
                                Icons.more_time_rounded,
                                color: AppThem.appBgColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount:value.visibleProducts,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Item :- ${index + 1}",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold,color: Colors.green,),
                                ),
                                const SizedBox(height: 8),
                                /// Product Name
                                TextField(
                                  controller: value.nameCtr[index],
                                  decoration: const InputDecoration(
                                    labelText: "Product Name",
                                    prefixIcon: Icon(Icons.inventory),
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: value.qtyCtr[index],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Quantity",
                                          prefixIcon: Icon(Icons.scale),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (_) => value.calculate(index),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        value: value.selectedUnit[index],
                                        items: value.units.map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          value.selectedUnit[index] = val!;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Unit",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                /// Rate
                                TextField(
                                  controller: value.rateCtr[index],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Rate per unit",
                                    prefixIcon: Icon(Icons.currency_rupee),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) =>value.calculate(index),
                                ),
                                const SizedBox(height: 6),
                                /// Amount
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Amount : ₹ ${value.amount[index].toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  /// Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "₹ ${value.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18,
                            color: Colors.green),

                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Save Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: AppThem.appBgColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: value.totalAmount == 0
                        ? null
                        : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ItemListScreen(),
                          ));
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      "Save Bill",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
