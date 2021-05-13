import 'package:dro_test/schemas/product_schema.dart';
import 'package:dro_test/views/products/screen/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controllers/product_provider.dart';

import '../../../schemas/product_schema.dart';

class ProductItem extends StatefulWidget {
  ProductItem(
      {this.refresh, this.productProvider, this.fromSearch, this.scaffoldKey});

  final Function refresh;
  final ProductProvider productProvider;
  final int fromSearch;
  final scaffoldKey;

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductSchema>(context);

    var formatPrice = NumberFormat.currency(locale: "en_US", name: "N");

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetail.routeName,
            arguments: {"product": product});
      },
      child: Material(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(10),
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/product_images/' + product.image,
                fit: BoxFit.cover,
                height: 150,
                width: 400,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${product.productName}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.subtitle2.color,
                    ),
                  ),
                  Text(
                    "${product.otherName}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                  Text(
                    "${product.weightInfo}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Theme.of(context).backgroundColor,
                      label: Text(
                          "${formatPrice.format(double.parse(product.sellingPrice))}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle1.color,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
