// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int? productId;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? productCode;
  String? productName;
  String? productDescription;
  String? productUom;
  String? productRate;
  String? productDocument;
  String? productImage;
  int? isSynced = 0;

  ProductModel({
    this.productId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
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
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    productCode: json["product_code"],
    productName: json["product_name"],
    productDescription: json["product_description"],
    productUom: json["product_uom"],
    productRate: json["product_rate"],
    productDocument: json["product_document"],
    productImage: json["product_image"],
    isSynced: json["isSynced"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": productId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "product_code": productCode,
    "product_name": productName,
    "product_description": productDescription,
    "product_uom": productUom,
    "product_rate": productRate,
    "product_document": productDocument,
    "product_image": productImage,
    "isSynced": isSynced ?? 0,
  };
}
