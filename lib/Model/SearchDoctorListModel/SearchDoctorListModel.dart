// To parse this JSON data, do
//
//     final searchDoctorListModel = searchDoctorListModelFromJson(jsonString);

import 'dart:convert';

//List<SearchDoctorListModel> searchDoctorListModelFromJson(String str) => List<SearchDoctorListModel>.from(json.decode(str).map((x) => SearchDoctorListModel.fromJson(x)));

//String searchDoctorListModelToJson(List<SearchDoctorListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchDoctorListModel {
    SearchDoctorListModel({
      required   this.id,
      required  this.firstName,
      required  this.lastName,
      required  this.fullName,
      required  this.education,
      required  this.designation,
      required this.image,
      required  this.aboutDoctor,
      required  this.phone,
      required  this.alternateNumber,
      required  this.emailId,
      required  this.address,
      required  this.dob,
      required  this.onPayroll,
      required  this.consultant,
      required  this.teleConsult,
      required  this.videoConsult,
      required  this.doj,
      required  this.dol,
      required  this.anniversary,
      required  this.createdBy,
      required  this.createdAt,
      required  this.updatedBy,
      required  this.updatedAt,
      required  this.isActive,
      required  this.isDeleted,
    });

    int id;
    String firstName;
    String lastName;
    String fullName;
    String education;
    String designation;
    String image;
    dynamic aboutDoctor;
    dynamic phone;
    dynamic alternateNumber;
    String emailId;
    dynamic address;
    dynamic dob;
    dynamic onPayroll;
    dynamic consultant;
    int teleConsult;
    int videoConsult;
    dynamic doj;
    dynamic dol;
    dynamic anniversary;
    dynamic createdBy;
    DateTime createdAt;
    dynamic updatedBy;
    DateTime updatedAt;
    int isActive;
    int isDeleted;

    factory SearchDoctorListModel.fromJson(Map<String, dynamic> json) => SearchDoctorListModel(
        id: json["Id"],
        firstName: json["FirstName"],
        lastName: json["LastName"] == null ? null : json["LastName"],
        fullName: json["FullName"],
        education: json["Education"],
        designation: json["Designation"] == null ? null : json["Designation"],
        image: json["Image"],
        aboutDoctor: json["AboutDoctor"],
        phone: json["Phone"],
        alternateNumber: json["AlternateNumber"],
        emailId: json["EmailId"] == null ? null : json["EmailId"],
        address: json["Address"],
        dob: json["Dob"],
        onPayroll: json["OnPayroll"],
        consultant: json["Consultant"],
        teleConsult: json["TeleConsult"] == null ? null : json["TeleConsult"],
        videoConsult: json["VideoConsult"] == null ? null : json["VideoConsult"],
        doj: json["Doj"],
        dol: json["Dol"],
        anniversary: json["Anniversary"],
        createdBy: json["CreatedBy"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedBy: json["UpdatedBy"],
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        isActive: json["IsActive"],
        isDeleted: json["IsDeleted"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "FirstName": firstName,
        "LastName": lastName == null ? null : lastName,
        "FullName": fullName,
        "Education": education,
        "Designation": designation == null ? null : designation,
        "Image": image,
        "AboutDoctor": aboutDoctor,
        "Phone": phone,
        "AlternateNumber": alternateNumber,
        "EmailId": emailId == null ? null : emailId,
        "Address": address,
        "Dob": dob,
        "OnPayroll": onPayroll,
        "Consultant": consultant,
        "TeleConsult": teleConsult == null ? null : teleConsult,
        "VideoConsult": videoConsult == null ? null : videoConsult,
        "Doj": doj,
        "Dol": dol,
        "Anniversary": anniversary,
        "CreatedBy": createdBy,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedAt": updatedAt.toIso8601String(),
        "IsActive": isActive,
        "IsDeleted": isDeleted,
    };
}
