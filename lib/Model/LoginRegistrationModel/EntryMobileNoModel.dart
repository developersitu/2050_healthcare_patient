// To parse this JSON data, do
//
//     final entryMobileNoModel = entryMobileNoModelFromJson(jsonString);

import 'dart:convert';

EntryMobileNoModel entryMobileNoModelFromJson(String str) => EntryMobileNoModel.fromJson(json.decode(str));

String entryMobileNoModelToJson(EntryMobileNoModel data) => json.encode(data.toJson());

class EntryMobileNoModel {
    EntryMobileNoModel({
      required this.status,
      required this.message,
      required this.userDetails,
    });

    bool status;
    String message;
    UserDetails userDetails;

    factory EntryMobileNoModel.fromJson(Map<String, dynamic> json) => EntryMobileNoModel(
        status: json["status"],
        message: json["message"],
        userDetails: UserDetails.fromJson(json["userDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "userDetails": userDetails.toJson(),
    };
}

class UserDetails {
    UserDetails({
      required this.mobileNumber,
    });

    String mobileNumber;

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        mobileNumber: json["MobileNumber"],
    );

    Map<String, dynamic> toJson() => {
        "MobileNumber": mobileNumber,
    };
}
