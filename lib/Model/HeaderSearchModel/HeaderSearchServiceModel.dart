// To parse this JSON data, do
//
//     final headerSearchServiceModel = headerSearchServiceModelFromJson(jsonString);

import 'dart:convert';

List<HeaderSearchServiceModel> headerSearchServiceModelFromJson(String str) => List<HeaderSearchServiceModel>.from(json.decode(str).map((x) => HeaderSearchServiceModel.fromJson(x)));

String headerSearchServiceModelToJson(List<HeaderSearchServiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HeaderSearchServiceModel {
    HeaderSearchServiceModel({
      required  this.id,
      required  this.subcategoryName,
    });

    int id;
    String subcategoryName;

    factory HeaderSearchServiceModel.fromJson(Map<String, dynamic> json) => HeaderSearchServiceModel(
        id: json["Id"],
        subcategoryName: json["SubcategoryName"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "SubcategoryName": subcategoryName,
    };
}
