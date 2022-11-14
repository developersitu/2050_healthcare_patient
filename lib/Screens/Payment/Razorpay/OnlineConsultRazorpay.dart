import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OnlineBookDoctorPage.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/Home/HomeNew.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';



class OnlineRazorpayPage extends StatelessWidget {
  const OnlineRazorpayPage({ Key? key }) : super(key: key);

  static String ? paymentId,price;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RazorpayScreen(),
    );
  }
}

class RazorpayScreen extends StatefulWidget {
  const RazorpayScreen({ Key? key }) : super(key: key);

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {

  
  late Razorpay _razorpay;


  ///// UpdateRazorPay Api Start ///////////
  updateRazorPayProcess() async {

    var response = await http.post(
      Uri.parse(updateRazorPayApi.toString()),
      headers: <String,String> {

      },
      body: {
        "RazorpayId" : Home.razorpay_OrderId.toString(),
        "paymentId" : OnlineRazorpayPage.paymentId.toString()
      }
    );
    // print(response.body);
    if(response.statusCode == 200){

      
      var items = json.decode(response.body) ?? {};
      bool database_status=json.decode(response.body)['status'] ?? false;
      String database_message=json.decode(response.body)['message'] ?? "failed";

      
     
      print('update razorpay body');
      print(items);
      
      if(database_status){
       
        showTopSnackBar(
          context,
          
          CustomSnackBar.success(
           // backgroundColor: Colors.red,
            message: database_message
                
          ),
        ); 

        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>BottomNavigationBarPage()));
             
      }
      if (database_status==false) {
       // scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(message.toString()))); 
       
        showTopSnackBar(
          context,
          
          CustomSnackBar.error(
           // backgroundColor: Colors.red,
            message: database_message
                
          ),
        ); 
      }  
      
     

    }else{
     
     
    }
  }
  ///// UpdateRazorPay Api End ///////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeRazorPay();
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     _razorpay.clear();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    launchRazorPay();
  }

  void launchRazorPay() {
    int amountToPay = int.parse(OnlineBookDoctorPage.price.toString()) * 100;

    var options = {
      'key': 'rzp_test_sUnWIb2sawiKlT',
      'order_id': Home.razorpay_OrderId.toString(),
       
      'amount': "$amountToPay",
      // 'name': name.text,
      // 'description': description.text,
      // 'prefill': {'contact': phoneNo.text, 'email': email.text}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }



  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");

    print("Payment id ///////////////////////////////////////////////////////////////");

     print(
        "${response.orderId} \n${response.paymentId} \n${response.signature}");

      setState(() {
        OnlineRazorpayPage.paymentId=response.paymentId.toString();
      });

    updateRazorPayProcess();

    

   
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payemt Failed");

    print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
  }



 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}


