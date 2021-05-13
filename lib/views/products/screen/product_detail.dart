import 'package:dro_test/constants/constants.dart';
import 'package:dro_test/schemas/product_schema.dart';
import 'package:dro_test/views/products/screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controllers/product_provider.dart';

import '../../../schemas/product_schema.dart';

class ProductDetail extends StatefulWidget {
  static const routeName = '/product_detail';

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProductSchema product;
  ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Constants.UI_OVERLAY);
    _productProvider = Provider.of<ProductProvider>(context);
    var formatPrice = NumberFormat.currency(locale: "en_US", name: "N");

    if (product == null) {
      final routeArgs = ModalRoute.of(context).settings.arguments
          as Map<String, ProductSchema>;
      product = routeArgs["product"];
      final res = _productProvider.fetchCartedProducts.firstWhere(
          (e) => e.productID == product.productID,
          orElse: () => null);

      if (res != null) product = res;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Theme.of(context).primaryColorLight,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff9F5DE2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 5),
                Text(
                  "${_productProvider.selectedForSale.length}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'assets/product_images/' + product.image,
                fit: BoxFit.cover,
                height: 250,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${product.productName}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Theme.of(context).textTheme.subtitle2.color,
                    ),
                  ),
                  Text(
                    "${product.otherName}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.subtitle2.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "SOLD BY",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${product.seller}",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (int.parse(product.itemsSelected) ==
                                            0) return;
                                        setState(() {
                                          product.itemsSelected = (int.parse(
                                                      product.itemsSelected) -
                                                  1)
                                              .toString();
                                          _productProvider
                                              .addProductToBag(product);
                                        });
                                      },
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 10),
                                    Text(product.itemsSelected,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        if (int.parse(product.itemsSelected) >
                                            int.parse(product.itemsLeft))
                                          return;
                                        setState(() {
                                          product.itemsSelected = (int.parse(
                                                      product.itemsSelected) +
                                                  1)
                                              .toString();
                                          _productProvider
                                              .addProductToBag(product);
                                        });
                                      },
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                margin: EdgeInsets.only(top: 25),
                                child: Text(
                                  product.unit,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Text(
                              "${formatPrice.format(double.parse(product.sellingPrice))}",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                alignment: Alignment.topLeft,
                child: Text("PRODUCT DETAILS",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/drugs.svg',
                          semanticsLabel: 'vector',
                          width: 24,
                          color: Color(0xff9F5DE2),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "PACK SIZE",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${product.size}",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/qr-code.svg',
                          semanticsLabel: 'vector',
                          width: 20,
                          color: Color(0xff9F5DE2),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "PRODUCT ID",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${product.productID}",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/pill.svg',
                      semanticsLabel: 'vector',
                      width: 24,
                      color: Color(0xff9F5DE2),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "CONSTITUENT",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "${product.productName}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.subtitle2.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/packet.svg',
                      semanticsLabel: 'vector',
                      width: 24,
                      color: Color(0xff9F5DE2),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "DISPENSED IN",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "${product.container}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.subtitle2.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "1 pack of ${product.productName} contains ${product.size.split('x')[0]} unit(s) of ${product.size.split('x')[1]} tablets",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30, left: 32, right: 32),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    label: Text("Add to bag"),
                    icon: SvgPicture.asset('assets/svg/bag.svg',
                        semanticsLabel: 'vector',
                        width: 24,
                        color: Colors.white),
                    onPressed: () {
                      _productProvider.addProductToBag(product);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) {
                          return Stack(
                            children: [
                              AlertDialog(
                                content: Container(
                                  height: 235,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        "Successful",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "${product.productName} has been added to your bag",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            Navigator.of(context).pushNamed(
                                                CartScreen.routeName);
                                          },
                                          child: Text("View Bag"),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Theme.of(context)
                                                            .accentColor),
                                            padding: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    EdgeInsets.symmetric(
                                                        vertical: 16)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Done"),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Theme.of(context)
                                                            .accentColor),
                                            padding: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    EdgeInsets.symmetric(
                                                        vertical: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (MediaQuery.of(context).size.width / 2) +
                                    60,
                                left: (MediaQuery.of(context).size.width / 2) -
                                    25,
                                child: Material(
                                  color: Color(0xffFFFFFF),
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.check),
                                        iconSize: 24,
                                        onPressed: () {},
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Color(0xff9F5DE2)),
                      padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.symmetric(vertical: 12)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
