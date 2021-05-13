import 'package:dro_test/controllers/product_provider.dart';
import 'package:dro_test/schemas/product_schema.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../schemas/product_schema.dart';

// ignore: must_be_immutable
class CartItem extends StatefulWidget {
  CartItem({this.scaffoldKey, this.productProvider});

  final scaffoldKey;
  ProductProvider productProvider;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool showActionButton = false;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductSchema>(context);
    var formatPrice = NumberFormat.currency(locale: "en_US", name: "N");

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showActionButton = !showActionButton;
            });
          },
          child: Container(
            padding: EdgeInsets.all(8),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/product_images/' + product.image,
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "x${product.itemsSelected == "0" ? 1 : product.itemsSelected}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${product.productName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).textTheme.subtitle1.color,
                          ),
                        ),
                        Text(
                          "${product.otherName}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.subtitle1.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "${formatPrice.format(double.parse(product.sellingPrice))}",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle1.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showActionButton)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.productProvider.removeProductFromBag(product);
                  },
                  iconSize: 30,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (int.parse(product.itemsSelected) == 0) return;
                          setState(() {
                            product.itemsSelected =
                                (int.parse(product.itemsSelected) - 1)
                                    .toString();

                            widget.productProvider.addProductToBag(product);
                          });
                        },
                        color: Color(0xff9F5DE2),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(product.itemsSelected,
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (int.parse(product.itemsSelected) >
                              int.parse(product.itemsLeft)) return;
                          setState(() {
                            product.itemsSelected =
                                (int.parse(product.itemsSelected) + 1)
                                    .toString();
                            widget.productProvider.addProductToBag(product);
                          });
                        },
                        color: Color(0xff9F5DE2),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
      ],
    );
  }
}
