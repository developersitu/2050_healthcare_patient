// To parse this JSON data, do
//
//     final vallidOtpModel = vallidOtpModelFromJson(jsonString);

import 'dart:convert';

VallidOtpModel vallidOtpModelFromJson(String str) => VallidOtpModel.fromJson(json.decode(str));

String vallidOtpModelToJson(VallidOtpModel data) => json.encode(data.toJson());

class VallidOtpModel {
    VallidOtpModel({
      required  this.status,
      required  this.message,
      required  this.appUserDetails,
      required  this.userDetails,
    });

    bool status;
    String message;
    AppUserDetails appUserDetails;
    UserDetails userDetails;

    factory VallidOtpModel.fromJson(Map<String, dynamic> json) => VallidOtpModel(
        status: json["status"],
        message: json["message"],
        appUserDetails: AppUserDetails.fromJson(json["app_user_details"]),
        userDetails: UserDetails.fromJson(json["userDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "app_user_details": appUserDetails.toJson(),
        "userDetails": userDetails.toJson(),
    };
}

class AppUserDetails {
    AppUserDetails({
      required  this.userId,
      required  this.mobileNumber,
    });

    int userId;
    String mobileNumber;

    factory AppUserDetails.fromJson(Map<String, dynamic> json) => AppUserDetails(
        userId: json["user_id"],
        mobileNumber: json["MobileNumber"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "MobileNumber": mobileNumber,
    };
}

class UserDetails {
    UserDetails({
      required  this.id,
      required  this.fullName,
      required  this.email,
      required  this.mobileNumber,
      required  this.otp,
      required  this.address,
      required  this.city,
      required  this.state,
      required  this.image,
      required  this.pincode,
      required  this.password,
      required  this.createdAt,
      required  this.updatedAt,
    });

    int id;
    dynamic fullName;
    String email;
    String mobileNumber;
    int otp;
    String address;
    String city;
    String state;
    String image;
    String pincode;
    dynamic password;
    DateTime createdAt;
    DateTime updatedAt;

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["Id"],
        fullName: json["FullName"],
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        otp: json["Otp"],
        address: json["Address"],
        city: json["City"],
        state: json["State"],
        image: json["Image"],
        pincode: json["Pincode"],
        password: json["Password"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "FullName": fullName,
        "Email": email,
        "MobileNumber": mobileNumber,
        "Otp": otp,
        "Address": address,
        "City": city,
        "State": state,
        "Image": image,
        "Pincode": pincode,
        "Password": password,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
    };
}
