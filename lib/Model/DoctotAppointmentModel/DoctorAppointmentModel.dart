// To parse this JSON data, do
//
//     final doctorConsultModel = doctorConsultModelFromJson(jsonString);

import 'dart:convert';

DoctorConsultModel doctorConsultModelFromJson(String str) => DoctorConsultModel.fromJson(json.decode(str));

String doctorConsultModelToJson(DoctorConsultModel data) => json.encode(data.toJson());

class DoctorConsultModel {
    DoctorConsultModel({
      required  this.status,
      required  this.title,
      required  this.doctorName,
      required  this.spcializationName,
      required  this.consultInsert,
    });

    bool status;
    String title;
    String doctorName;
    String spcializationName;
    ConsultInsert consultInsert;

    factory DoctorConsultModel.fromJson(Map<String, dynamic> json) => DoctorConsultModel(
        status: json["status"],
        title: json["title"],
        doctorName: json["DoctorName"],
        spcializationName: json["SpcializationName"],
        consultInsert: ConsultInsert.fromJson(json["consultInsert"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "title": title,
        "DoctorName": doctorName,
        "SpcializationName": spcializationName,
        "consultInsert": consultInsert.toJson(),
    };
}

class ConsultInsert {
    ConsultInsert({
      required  this.doctorId,
      required  this.userId,
      required  this.specializationId,
      required  this.patientName,
      required  this.patientAge,
      required  this.mobileNumber,
      required  this.scheduleDate,
      required  this.slotId,
      required  this.consultationType,
      required  this.status,
    });

    String doctorId;
    String userId;
    String specializationId;
    String patientName;
    dynamic patientAge;
    String mobileNumber;
    String scheduleDate;
    String slotId;
    String consultationType;
    int status;

    factory ConsultInsert.fromJson(Map<String, dynamic> json) => ConsultInsert(
        doctorId: json["DoctorId"],
        userId: json["UserId"],
        specializationId: json["SpecializationId"],
        patientName: json["PatientName"],
        patientAge: json["PatientAge"],
        mobileNumber: json["MobileNumber"],
        scheduleDate: json["ScheduleDate"],
        slotId: json["SlotId"],
        consultationType: json["ConsultationType"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "DoctorId": doctorId,
        "UserId": userId,
        "SpecializationId": specializationId,
        "PatientName": patientName,
        "PatientAge": patientAge,
        "MobileNumber": mobileNumber,
        "ScheduleDate": scheduleDate,
        "SlotId": slotId,
        "ConsultationType": consultationType,
        "Status": status,
    };
}
