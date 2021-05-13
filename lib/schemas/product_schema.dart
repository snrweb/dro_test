import 'package:flutter/foundation.dart';

class ProductSchema extends ChangeNotifier {
  String productID;
  String productName;
  String otherName;
  String weightInfo;
  String sellingPrice;
  String description;
  String image;
  String itemsLeft;
  String itemsSelected;
  String seller;
  String unit;
  String size;
  String container;
  String createdAt;
  String updatedAt;

  ProductSchema({
    this.productID,
    this.productName,
    this.otherName,
    this.weightInfo,
    this.sellingPrice,
    this.description,
    this.image,
    this.itemsLeft,
    this.itemsSelected,
    this.seller,
    this.unit,
    this.size,
    this.container,
    this.createdAt,
    this.updatedAt,
  });
}
