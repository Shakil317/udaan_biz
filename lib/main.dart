import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mycalculator/RazorPayService/RazorPayViewModels/razor_pay_api_provider.dart';
import 'package:mycalculator/ViewModels/auth_service.dart';
import 'package:mycalculator/ViewModels/card_provider.dart';
import 'package:mycalculator/ViewModels/contact_provider.dart';
import 'package:mycalculator/ViewModels/generate_item_list_provider.dart';
import 'package:mycalculator/ViewModels/real_user_provider.dart';
import 'package:mycalculator/ViewModels/status_view_provider.dart';
import 'package:mycalculator/ViewModels/transition_history_provider.dart';
import 'package:mycalculator/screens/home_tab_bar_screen.dart';
import 'package:mycalculator/screens/user_registation_screen.dart';
import 'package:provider/provider.dart';
import 'RazorPayService/RazorPayViewModels/razor_pay_payment_provider.dart';
import 'ViewModels/advanced_calculater_provider.dart';
import 'ViewModels/calculate_provider.dart';
import 'ViewModels/real_transition_history_provider.dart';
import 'ViewModels/reals_view_provider.dart';
import 'ViewModels/uploades_provider.dart';
import 'ViewModels/user_profile_provider.dart';
import 'ViewModels/user_provider.dart';
import 'firebase_options.dart';
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalculateProvider()),
        ChangeNotifierProvider(create: (context) => AdvancedCalculatorProvider(),),
        ChangeNotifierProvider(create: (context) => ContactProvider(),),
        ChangeNotifierProvider(create: (context) => UserProvider(),),
        ChangeNotifierProvider(create: (context) => TransitionHistoryProvider(),),
        ChangeNotifierProvider(create: (context) => UserProfileProvider(),) ,
        ChangeNotifierProvider(create: (context) => AuthService(),),
        ChangeNotifierProvider(create: (context) => CardProvider(),),
        ChangeNotifierProvider(create: (context) => RazorPayProvider(),),
        ChangeNotifierProvider(create: (context) => PaymentPaymentProvider(),),
        ChangeNotifierProvider(create: (context) => StatusViewProvider(),),
        ChangeNotifierProvider(create: (context) => RealUserProvider(),),
        ChangeNotifierProvider(create: (context) => UploaderProvider(),),
        ChangeNotifierProvider(create: (context) => RealsViewProvider(),),
        ChangeNotifierProvider(create: (context) => RealTransitionHistoryProvider(),),
        ChangeNotifierProvider(create: (context) => GenerateItemListProvider(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home:  user != null ?  const HomeTabBarScreens(): const UserRegistationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

}




