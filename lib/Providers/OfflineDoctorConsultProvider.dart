
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:healthcare2050/Model/DoctotAppointmentModel/DoctorAppointmentModel.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OnlineBookDoctorPage.dart';
import 'package:healthcare2050/Screens/BookDoctorPage/OfflineBookDoctorPage.dart';
import 'package:http/http.dart' as http;



class OfflineDoctorConsultProvider extends ChangeNotifier{

  late DoctorConsultModel doctorConsultModel;
  
  sendDataToOfflineDoctorConsultProvider(context,doctorId,userId,specializationId,patientName,patientAge,mobileNumber,scheduleDate,slotId,consultType) async{
    
   
    doctorConsultModel = await postDataToOfflineDoctorConsult(context,doctorId,userId,specializationId,patientName,patientAge,mobileNumber,scheduleDate,slotId,consultType);

    
   }
}