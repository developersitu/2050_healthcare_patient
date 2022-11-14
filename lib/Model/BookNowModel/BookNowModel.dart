// To parse this JSON data, do
//
//     final bookNowModel = bookNowModelFromJson(jsonString);

import 'dart:convert';

BookNowModel bookNowModelFromJson(String str) => BookNowModel.fromJson(json.decode(str));

String bookNowModelToJson(BookNowModel data) => json.encode(data.toJson());

class BookNowModel {
    BookNowModel({
      required  this.status,
      required  this.title,
      required  this.message,
    });

    bool status;
    String title;
    String message;

    factory BookNowModel.fromJson(Map<String, dynamic> json) => BookNowModel(
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
