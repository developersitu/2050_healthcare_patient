// To parse this JSON data, do
//
//     final profileImageUploadModel = profileImageUploadModelFromJson(jsonString);

import 'dart:convert';

ProfileImageUploadModel profileImageUploadModelFromJson(String str) => ProfileImageUploadModel.fromJson(json.decode(str));

String profileImageUploadModelToJson(ProfileImageUploadModel data) => json.encode(data.toJson());

class ProfileImageUploadModel {
    ProfileImageUploadModel({
      required  this.image,
      required  this.status,
      required  this.title,
    });

    String image;
    bool status;
    String title;

    factory ProfileImageUploadModel.fromJson(Map<String, dynamic> json) => ProfileImageUploadModel(
        image: json["Image"],
        status: json["status"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "Image": image,
        "status": status,
        "title": title,
    };
}
