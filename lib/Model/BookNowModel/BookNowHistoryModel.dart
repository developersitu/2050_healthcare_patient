// To parse this JSON data, do
//
//     final bookNowHistoryModel = bookNowHistoryModelFromJson(jsonString);

import 'dart:convert';

List<BookNowHistoryModel> bookNowHistoryModelFromJson(String str) => List<BookNowHistoryModel>.from(json.decode(str).map((x) => BookNowHistoryModel.fromJson(x)));

String bookNowHistoryModelToJson(List<BookNowHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookNowHistoryModel {
  BookNowHistoryModel({
    required  this.id,
    required  this.bookingCode,
    required  this.cityId,
    required  this.cityName,
    required  this.subcategoryId,
    required  this.subcategoryName,
    required  this.firstName,
    required  this.lastName,
    required  this.fullName,
    required  this.mobile,
    required  this.email,
    required  this.bookingStatus,
    required  this.createdBy,
    required  this.createdAt,
  });

    int id;
    String bookingCode;
    int cityId;
    String cityName;
    int subcategoryId;
    String subcategoryName;
    String firstName;
    String lastName;
    String fullName;
    int mobile;
    String email;
    String bookingStatus;
    int createdBy;
    String createdAt;

    factory BookNowHistoryModel.fromJson(Map<String, dynamic> json) => BookNowHistoryModel(
        id: json["Id"],
        bookingCode: json["BookingCode"],
        cityId: json["CityId"],
        cityName: json["CityName"],
        subcategoryId: json["SubcategoryId"],
        subcategoryName: json["SubcategoryName"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        fullName: json["FullName"],
        mobile: json["Mobile"],
        email: json["Email"],
        bookingStatus: json["BookingStatus"],
        createdBy: json["CreatedBy"],
        createdAt: json["CreatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "BookingCode": bookingCode,
        "CityId": cityId,
        "CityName": cityName,
        "SubcategoryId": subcategoryId,
        "SubcategoryName": subcategoryName,
        "FirstName": firstName,
        "LastName": lastName,
        "FullName": fullName,
        "Mobile": mobile,
        "Email": email,
        "BookingStatus": bookingStatus,
        "CreatedBy": createdBy,
        "CreatedAt": createdAt,
    };
}
