
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:healthcare2050/Model/DoctotAppointmentModel/DoctorAppointmentModel.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OnlineBookDoctorPage.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OfflineBookDoctorPage.dart';
import 'package:http/http.dart' as http;


class OnlineDoctorConsultProvider extends ChangeNotifier{

  late DoctorConsultModel doctorConsultModel;
  
  sendDataToOnlineDoctorConsultProvider(context,doctorId,userId,specializationId,patientName,patientAge,mobileNumber,scheduleDate,slotId) async{
    
   
    doctorConsultModel = await postDataToOnlineDoctorConsult(context,doctorId,userId,specializationId,patientName,patientAge,mobileNumber,scheduleDate,slotId);

    
   }
}