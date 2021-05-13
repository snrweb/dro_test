import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../schemas/product_schema.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductSchema> selectedForSale = [];
  Map<String, List<ProductSchema>> productsMap = {};
  List<ProductSchema> productsList = [];
  List<ProductSchema> searchedProductsList = [];
  int totalItemsSelected = 0;
  double profitForCurrentSale = 0;
  double totalPrice = 0;
  double totalCostPrice = 0;
  double totalPaid = 0;
  bool isCleared = false;
  int productCount = 0;

  Future<List<ProductSchema>> fetchProducts() async {
    final res = await ProductModel().selectProducts();
    if (res == null) return [];
    productsList = setProduct(res);
    return productsList;
  }

  bool addProductToBag(ProductSchema product) {
    selectedForSale.removeWhere((e) => e.productID == product.productID);
    selectedForSale.add(product);
    notifyListeners();
    return true;
  }

  void removeProductFromBag(ProductSchema product) {
    selectedForSale.removeWhere((e) => e.productID == product.productID);
    notifyListeners();
  }

  List<ProductSchema> get fetchCartedProducts {
    return this.selectedForSale;
  }

  Future<List<ProductSchema>> search(productName) async {
    final res = await ProductModel().searchProductByName(productName);
    searchedProductsList = setProduct(res);
    notifyListeners();
    return searchedProductsList;
  }

  Future<int> getProductCount() async {
    final res = await ProductModel().getProductCount();
    productCount = res;
    notifyListeners();
    return productCount;
  }

  List<ProductSchema> setProduct(List<Map<String, dynamic>> res) {
    List<ProductSchema> items = [];

    res.forEach((e) {
      items.add(
        new ProductSchema(
          productID: e["productID"],
          productName: e["productName"],
          otherName: e["otherName"],
          weightInfo: e["weightInfo"],
          sellingPrice: e["sellingPrice"],
          seller: e["seller"],
          description: e["description"],
          image: e["image"],
          unit: e["unit"],
          size: e["size"],
          container: e["container"],
          itemsLeft: e["itemsLeft"],
          itemsSelected: e["itemsSelected"],
          createdAt: e["createdAt"],
          updatedAt: e["updatedAt"],
        ),
      );
    });
    return items;
  }
}
