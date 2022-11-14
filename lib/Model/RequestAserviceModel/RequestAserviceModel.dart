// To parse this JSON data, do
//
//     final requestAserviceModel = requestAserviceModelFromJson(jsonString);

import 'dart:convert';

RequestAserviceModel requestAserviceModelFromJson(String str) => RequestAserviceModel.fromJson(json.decode(str));

String requestAserviceModelToJson(RequestAserviceModel data) => json.encode(data.toJson());

class RequestAserviceModel {
    RequestAserviceModel({
      required  this.status,
      required  this.title,
      required  this.message,
    });

    bool status;
    String title;
    String message;

    factory RequestAserviceModel.fromJson(Map<String, dynamic> json) => RequestAserviceModel(
        status: json["status"],
        title: json["title"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "title": title,
        "message": message,
    };
}
