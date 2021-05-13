import 'package:dro_test/constants/constants.dart';
import 'package:dro_test/views/products/components/cart_item.dart';
import 'package:dro_test/views/products/components/product_cart_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../widget/loader_item.dart';
import './product_search_screen.dart';
import '../../../controllers/product_provider.dart';
import '../../../schemas/product_schema.dart';

import '../../products/components/product_item.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<ProductSchema>> products;

  Stream<List<ProductSchema>> productStream;
  ScrollController _scrollController = new ScrollController();
  ProductProvider _productProvider;
  bool showSearchBar = false;
  bool hasFinishedLoading = false;
  int start = 0;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getProducts();
      }
    });

    products = _productProvider.fetchProducts();
  }

  void getProducts() {
    products = _productProvider.fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Constants.UI_OVERLAY);

    _productProvider = Provider.of<ProductProvider>(context);
    var formatPrice = NumberFormat.currency(locale: "en_US", name: "N");

    return SafeArea(
      child: FutureBuilder<List<ProductSchema>>(
          future: products,
          builder:
              (BuildContext context, AsyncSnapshot<List<ProductSchema>> s) {
            return s.hasData
                ? Scaffold(
                    key: _scaffoldKey,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const BackButtonIcon(),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Colors.black87),
                      backgroundColor: Theme.of(context).primaryColorLight,
                      elevation: 0,
                      title: Text(
                        "${s.data.length} item(s)",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.import_export_outlined,
                                          size: 24,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.filter_alt_outlined,
                                          size: 24,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.search_outlined,
                                          size: 24,
                                        ),
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed(
                                                ProductSearchScreen.routeName)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height - 170,
                              child: GridView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 30,
                                  childAspectRatio: 3 / 4.6,
                                ),
                                itemCount: s.data.length + 1,
                                itemBuilder: (context, index) {
                                  if (s.data.length == index) {
                                    if (s.data.length %
                                                Constants.DB_FETCH_LIMIT ==
                                            0 &&
                                        !hasFinishedLoading) {
                                      return CupertinoActivityIndicator();
                                    }
                                    return Center();
                                  } else {
                                    return ChangeNotifierProvider.value(
                                      value: s.data[index],
                                      child: ProductItem(
                                          scaffoldKey: _scaffoldKey,
                                          productProvider: _productProvider),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Consumer<ProductProvider>(
                          builder: (ctx, p, child) => DraggableScrollableSheet(
                            initialChildSize: 0.1,
                            minChildSize: 0.1,
                            maxChildSize: 0.96,
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return ProductCartDisplay(
                                  productProvider: _productProvider,
                                  formatPrice: formatPrice,
                                  scrollController: scrollController);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : MyCircularProgressIndicator();
          }),
    );
  }
}
