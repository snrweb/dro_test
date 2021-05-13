List<Map<String, String>> products = [
  {
    "productID": "1",
    "productName": "Kezitil Susp",
    "otherName": "Cefuroxime Axetil",
    "weightInfo": "Oral suspension - 125mg",
    "sellingPrice": "200",
    "seller": "Emzor Pharmaceuticals",
    "description":
        "Create a replica of DRO Health’s pharmacy feature using the codebase architecture and coding patterns highlighted in section 1 above",
    "image": "dro_kezitil.jpg",
    "itemsLeft": "25",
    "itemsSelected": "0",
    "unit": "Pieces",
    "size": "3x10",
    "container": "Packs",
    "createdAt": DateTime.now().toString(),
    "updatedAt": "",
  },
  {
    "productID": "2",
    "productName": "Kezitil",
    "otherName": "Cefuroxime Axetil",
    "weightInfo": "Tablet - 250mg",
    "sellingPrice": "200",
    "seller": "Emzor Pharmaceuticals",
    "description":
        "Create a replica of DRO Health’s pharmacy feature using the codebase architecture and coding patterns highlighted in section 1 above",
    "image": "dro_kezitil_2.jpg",
    "itemsLeft": "25",
    "itemsSelected": "0",
    "unit": "Pieces",
    "size": "3x5",
    "container": "Packs",
    "createdAt": DateTime.now().toString(),
    "updatedAt": "",
  },
  {
    "productID": "3",
    "productName": "Garlic Oil",
    "otherName": "Garlic Oil",
    "weightInfo": "Soft Gel - 650mg",
    "sellingPrice": "200",
    "seller": "Emzor Pharmaceuticals",
    "description":
        "Create a replica of DRO Health’s pharmacy feature using the codebase architecture and coding patterns highlighted in section 1 above",
    "image": "dro_kezitil_3.jpg",
    "itemsLeft": "25",
    "itemsSelected": "0",
    "unit": "Pieces",
    "size": "4x8",
    "container": "Packs",
    "createdAt": DateTime.now().toString(),
    "updatedAt": "",
  },
  {
    "productID": "4",
    "productName": "Folic Acid (100)",
    "otherName": "Folic Acid",
    "weightInfo": "Tablet - 5mg",
    "sellingPrice": "200",
    "seller": "Emzor Pharmaceuticals",
    "description":
        "Create a replica of DRO Health’s pharmacy feature using the codebase architecture and coding patterns highlighted in section 1 above",
    "image": "dro_kezitil_4.jpg",
    "itemsLeft": "25",
    "itemsSelected": "0",
    "unit": "Pieces",
    "size": "3x10",
    "container": "Packs",
    "createdAt": DateTime.now().toString(),
    "updatedAt": "",
  },
];

class ProductModel {
  Future<List<Map<String, dynamic>>> selectProducts() async {
    return products;
  }

  Future<List<Map<String, dynamic>>> searchProductByName(productName) async {
    List<Map<String, dynamic>> searchedProduct = [];
    products.map((e) => {
          if (e["productName"].contains(productName)) {searchedProduct.add(e)}
        });

    return await Future.delayed(Duration(milliseconds: 200), () {
      return searchedProduct;
    });
  }

  Future<int> getProductCount() async {
    return products.length;
  }

  Future<Map<String, dynamic>> selectByProductID(String productID) async {
    return await Future.delayed(Duration(milliseconds: 200), () {
      return products.firstWhere((e) => e["productID"] == productID);
    });
  }
}
