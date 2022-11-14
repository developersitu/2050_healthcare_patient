// To parse this JSON data, do
//
//     final profileDetailsUpdateModel = profileDetailsUpdateModelFromJson(jsonString);

import 'dart:convert';

ProfileDetailsUpdateModel profileDetailsUpdateModelFromJson(String str) => ProfileDetailsUpdateModel.fromJson(json.decode(str));

String profileDetailsUpdateModelToJson(ProfileDetailsUpdateModel data) => json.encode(data.toJson());

class ProfileDetailsUpdateModel {
    ProfileDetailsUpdateModel({
      required  this.status,
      required  this.title,
      required  this.userDetails,
    });

    String status;
    String title;
    UserDetails userDetails;

    factory ProfileDetailsUpdateModel.fromJson(Map<String, dynamic> json) => ProfileDetailsUpdateModel(
        status: json["status"],
        title: json["title"],
        userDetails: UserDetails.fromJson(json["userDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "title": title,
        "userDetails": userDetails.toJson(),
    };
}

class UserDetails {
    UserDetails({
      required  this.email,
      required  this.mobileNumber,
      required  this.city,
      required  this.state,
      required  this.pincode,
      required  this.address,
    });

    String email;
    String mobileNumber;
    String city;
    String state;
    String pincode;
    String address;

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        city: json["City"],
        state: json["State"],
        pincode: json["Pincode"],
        address: json["Address"],
    );

    Map<String, dynamic> toJson() => {
        "Email": email,
        "MobileNumber": mobileNumber,
        "City": city,
        "State": state,
        "Pincode": pincode,
        "Address": address,
    };
}
