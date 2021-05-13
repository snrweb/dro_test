import 'package:dro_test/constants/constants.dart';
import 'package:dro_test/views/products/components/cart_item.dart';
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
          ListView.builder(
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
                            color: Theme.of(context).textTheme.subtitle1.color,
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
            ),
          )
        ],
      ),
    );
  }
}
