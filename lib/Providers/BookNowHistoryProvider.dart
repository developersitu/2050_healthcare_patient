import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:healthcare2050/Api/Api.dart';
import 'package:healthcare2050/Screens/BookNow/BookNowHistory.dart';
import 'package:healthcare2050/Screens/BookNow/PreviousBookNowHistory.dart';
import 'package:healthcare2050/Screens/Home/Home.dart';
import 'package:healthcare2050/Screens/Service/Service.dart';
import 'package:http/http.dart' as http;


class BookNowHistoryListProvider with ChangeNotifier{

  List bookNowHistoryList=[];
  bool ? serverStatus;
  String ? serverMessage;
  bool isloading=true;

  

  Map<String, String> queryParams = {
   //'Id': BookNowHistory.userid.toString(),
   'Id': BookNowHistory.userid.toString(),

   
  };

  Future fetchBookingNowHistory() async {
    
     
    var bookNowHistor_Url= doctorAppointmentScheduleListApi;
    final  response = await http.get(
      Uri.parse(bookNowHistor_Url).replace(queryParameters: queryParams),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    // print(response.body);
    if(response.statusCode == 200){

      isloading = false;
      var HistoryList = json.decode(response.body)['BookingDetail'] ?? [];
      bookNowHistoryList=HistoryList;
      serverStatus = json.decode(response.body)['status'];
      serverMessage = json.decode(response.body)['message'];
      
      notifyListeners();

      print("bookNowHistoryList //////////////////////////////////////////////////////////////////////////////////////////");
      print(bookNowHistoryList.toString());
      print(serverStatus.toString());
      
    }
    else{
      bookNowHistoryList = [];
      isloading=true;
      notifyListeners();
    }
  }

}