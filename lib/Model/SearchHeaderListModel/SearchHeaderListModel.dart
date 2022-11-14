// To parse this JSON data, do
//
//     final searchHeaderListModel = searchHeaderListModelFromJson(jsonString);

import 'dart:convert';

List<SearchHeaderListModel> searchHeaderListModelFromJson(String str) => List<SearchHeaderListModel>.from(json.decode(str).map((x) => SearchHeaderListModel.fromJson(x)));

String searchHeaderListModelToJson(List<SearchHeaderListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchHeaderListModel {
    SearchHeaderListModel({
      required  this.id,
      required  this.cityId,
      required  this.categoryName,
      required  this.description,
      required  this.content,
      required  this.categoryMobileContent,
      required  this.icon,
      required  this.image,
      required  this.backgroundImage,
      required  this.createdBy,
      required  this.createdAt,
      required  this.updateAt,
      required  this.updateBy,
      required  this.isActive,
      required  this.isDelete,
      required  this.categoryId,
      required  this.subcategoryName,
      required  this.headerName,
      required  this.subcategoryContent,
      required  this.subcategoryUrl,
      required  this.subcategoryMobileContent,
      required  this.subBackgroundImage,
      required  this.isDeleted,
    });

    int id;
    String cityId;
    String categoryName;
    String description;
    String content;
    dynamic categoryMobileContent;
    String icon;
    dynamic image;
    String backgroundImage;
    dynamic createdBy;
    DateTime createdAt;
    DateTime updateAt;
    dynamic updateBy;
    int isActive;
    int isDelete;
    int categoryId;
    String subcategoryName;
    String headerName;
    String subcategoryContent;
    dynamic subcategoryUrl;
    String subcategoryMobileContent;
    String subBackgroundImage;
    int isDeleted;

    factory SearchHeaderListModel.fromJson(Map<String, dynamic> json) => SearchHeaderListModel(
        id: json["Id"],
        cityId: json["CityId"],
        categoryName: json["CategoryName"],
        description: json["Description"],
        content: json["Content"],
        categoryMobileContent: json["CategoryMobileContent"],
        icon: json["Icon"],
        image: json["Image"],
        backgroundImage: json["BackgroundImage"],
        createdBy: json["CreatedBy"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updateAt: DateTime.parse(json["UpdateAt"]),
        updateBy: json["UpdateBy"],
        isActive: json["IsActive"],
        isDelete: json["IsDelete"],
        categoryId: json["CategoryId"],
        subcategoryName: json["SubcategoryName"],
        headerName: json["HeaderName"],
        subcategoryContent: json["SubcategoryContent"],
        subcategoryUrl: json["SubcategoryUrl"],
        subcategoryMobileContent: json["SubcategoryMobileContent"],
        subBackgroundImage: json["SubBackgroundImage"],
        isDeleted: json["IsDeleted"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "CityId": cityId,
        "CategoryName": categoryName,
        "Description": description,
        "Content": content,
        "CategoryMobileContent": categoryMobileContent,
        "Icon": icon,
        "Image": image,
        "BackgroundImage": backgroundImage,
        "CreatedBy": createdBy,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdateAt": updateAt.toIso8601String(),
        "UpdateBy": updateBy,
        "IsActive": isActive,
        "IsDelete": isDelete,
        "CategoryId": categoryId,
        "SubcategoryName": subcategoryName,
        "HeaderName": headerName,
        "SubcategoryContent": subcategoryContent,
        "SubcategoryUrl": subcategoryUrl,
        "SubcategoryMobileContent": subcategoryMobileContent,
        "SubBackgroundImage": subBackgroundImage,
        "IsDeleted": isDeleted,
    };
}
