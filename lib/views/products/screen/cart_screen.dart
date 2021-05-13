import 'package:dro_test/constants/constants.dart';
import 'package:dro_test/views/products/components/cart_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../widget/loader_item.dart';
import './product_search_screen.dart';
import '../../../controllers/product_provider.dart';
import '../../../schemas/product_schema.dart';

import '../../products/components/product_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ProductSchema> products;

  ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);

    products = _productProvider.fetchCartedProducts;
  }

  @override
  Widget build(BuildContext context) {
    _productProvider = Provider.of<ProductProvider>(context);
    var formatPrice = NumberFormat.currency(locale: "en_US", name: "N");

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          "${products.length} item(s)",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 120,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
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
                        SizedBox(height: 20),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 140),
                    itemCount: _productProvider.fetchCartedProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: _productProvider.fetchCartedProducts[index],
                        child: CartItem(productProvider: _productProvider),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  formatPrice.format(_productProvider
                                      .fetchCartedProducts
                                      .map((prd) =>
                                          double.parse(prd.sellingPrice) *
                                          int.parse(prd.itemsSelected))
                                      .fold(
                                          0, (prev, amount) => prev + amount)),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .color,
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
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.white),
                                padding: MaterialStateProperty.resolveWith(
                                  (states) =>
                                      EdgeInsets.symmetric(vertical: 16),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
