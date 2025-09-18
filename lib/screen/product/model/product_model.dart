// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int? productId;
  String? productCode;
  String? productName;
  String? productDescription;
  String? productUom;
  String? productRate;
  String? productDocument;
  String? productImage;
  int? isSynced;

  ProductModel({
    this.productId,
    this.productCode,
    this.productName,
    this.productDescription,
    this.productUom,
    this.productRate,
    this.productDocument,
    this.productImage,
    this.isSynced = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json["id"],
    productCode: json["product_code"],
    productName: json["product_name"],
    productDescription: json["product_description"],
    productUom: json["product_uom"],
    productRate: json["product_rate"],
    productDocument: json["product_document"],
    productImage: json["product_image"],
    isSynced: json["isSynced"],
  );

  Map<String, dynamic> toJson() => {
    "id": productId,
    "product_code": productCode,
    "product_name": productName,
    "product_description": productDescription,
    "product_uom": productUom,
    "product_rate": productRate,
    "product_document": productDocument,
    "product_image": productImage,
    "isSynced": isSynced,
  };
}
