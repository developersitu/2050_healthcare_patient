
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:healthcare2050/Model/DoctotAppointmentModel/DoctorAppointmentModel.dart';
import 'package:healthcare2050/Model/RequestAserviceModel/RequestAserviceModel.dart';
import 'package:healthcare2050/Screens/RequestAService/RequestAservice.dart';
import 'package:http/http.dart' as http;


class RequestAServiceProvider extends ChangeNotifier{

  late RequestAserviceModel requestAserviceModel;
  
  sendDataToRequestAServiceProvider(context,firstname,lastname,email,service,mobile,cityid) async{

    requestAserviceModel = await postDataRequestAservice(context,firstname,lastname,email,service,mobile,cityid);

    notifyListeners();
    
  }
}