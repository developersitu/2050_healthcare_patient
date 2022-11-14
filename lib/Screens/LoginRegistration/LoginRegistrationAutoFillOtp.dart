
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Model/LoginRegistrationModel/VallidOtpModel.dart';
import 'package:healthcare2050/Screens/BottomNavigationBar/BottomNavigationBarPage.dart';
import 'package:healthcare2050/Screens/LoginRegistration/LoginRegistration.dart';
import 'package:healthcare2050/Screens/NoInternetPage/NoInternetLoginRegistrationOtp.dart';
import 'package:healthcare2050/Screens/SplashScreen/SplashScreen.dart';
import 'package:healthcare2050/constants/constants.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';



class LoginRegistrationAutoFillOtp extends StatelessWidget {
  const LoginRegistrationAutoFillOtp({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginRegistrationOtpScreen(),
    );
  }
}

class LoginRegistrationOtpScreen extends StatefulWidget {
  const LoginRegistrationOtpScreen({Key? key}) : super(key: key);

  

  @override
  _LoginRegistrationOtpScreenState createState() => _LoginRegistrationOtpScreenState();
}

class _LoginRegistrationOtpScreenState extends State<LoginRegistrationOtpScreen> with  SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.


  AnimationController? _animationController; // added
  int levelClock = 2 * 60;  // added
  


  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));

    _animationController!.forward();

    _listenSmsCode();
    
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



   _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }


  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

   return Scaffold(
      backgroundColor: const Color(0xffF5F4FD),
      appBar: AppBar(
        title: const Text("SMS OTP AutoFill"),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),


      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text("Verification"),
                  Text(
                    "We sent you a SMS Code",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "On number: +998993727053",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),


            Center(
              child: PinFieldAutoFill(
                codeLength: 6,
                autoFocus: true,
                decoration: UnderlineDecoration(
                  lineHeight: 2,
                  lineStrokeCap: StrokeCap.square,
                  bgColorBuilder: PinListenColorBuilder(
                      Colors.green.shade200, Colors.grey.shade200),
                  colorBuilder: const FixedColorBuilder(Colors.transparent),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Resend code after: "),
                Countdown(
                  animation: StepTween(
                    begin: levelClock, // THIS IS A USER ENTERED NUMBER
                    end: 0
                    
                  ).animate(_animationController!),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 56,
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                //?  use this code to get sms signature for your app
                // final String signature = await SmsAutoFill().getAppSignature;
                // print("Signature: $signature");

                _animationController!.reset();
                _animationController!.forward();
              },
              child: const Text("Resend"),
            ),
          ),
          SizedBox(
            height: 56,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                //Confirm and Navigate to Home Page
                //Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
                    
              },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      timerText,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}


