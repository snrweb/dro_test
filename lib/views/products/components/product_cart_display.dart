import 'package:dro_test/controllers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'cart_item.dart';

class ProductCartDisplay extends StatelessWidget {
  const ProductCartDisplay({
    Key key,
    @required ProductProvider productProvider,
    @required this.formatPrice,
    @required this.scrollController,
  })  : _productProvider = productProvider,
        super(key: key);

  final ProductProvider _productProvider;
  final NumberFormat formatPrice;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            spreadRadius: 2,
            blurRadius: 3,
          )
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Theme.of(context).primaryColor,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Icon(
                    Icons.drag_handle_outlined,
                    size: 30,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Bag",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "${_productProvider.fetchCartedProducts.length}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Tap on an item for add, remove and delete options",
                    style: TextStyle(
                      color: Color(0xFF2E0853),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 270,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 120),
              controller: scrollController,
              itemCount: _productProvider.fetchCartedProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: _productProvider.fetchCartedProducts[index],
                  child: CartItem(productProvider: _productProvider),
                );
              },
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height - 250),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        formatPrice.format(_productProvider.fetchCartedProducts
                            .map((prd) =>
                                double.parse(prd.sellingPrice) *
                                int.parse(prd.itemsSelected))
                            .fold(0, (prev, amount) => prev + amount)),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white),
                      padding: MaterialStateProperty.resolveWith(
                        (states) => EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                      ),
                    ),
                    child: Text(
                      "Checkout",
                      style: TextStyle(color: Color(0xff9F5DE2)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
