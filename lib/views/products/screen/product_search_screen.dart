import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/product_provider.dart';
import '../../../schemas/product_schema.dart';
import '../../../views/products/components/product_item.dart';
import '../../../widget/loader_item.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product_search';

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  Stream<List<ProductSchema>> _products;
  ProductProvider _productProvider;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalProduct = 0;

  @override
  void initState() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        key: _scaffoldKey,
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
            "$totalProduct item(s)",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
        body: Column(
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
                        onPressed: () {}),
                  ),
                ],
              ),
            ),
            Container(
              child: TextField(
                style: TextStyle(color: Color(0xff27214D)),
                autofocus: true,
                cursorColor: Color(0xff27214D),
                decoration: InputDecoration(
                  hintText: 'Search for crowdfunds',
                  hintStyle: TextStyle(color: Color(0xff86869E)),
                  filled: true,
                  fillColor: Color(0xffF3F4F9),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff86869E),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                ),
                onChanged: (value) {
                  if (value.length > 2) {
                    setState(() {
                      _products = _productProvider.search(value).asStream();
                    });
                  }
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 230,
              child: StreamBuilder<List<ProductSchema>>(
                  stream: _products,
                  builder: (context, snapshot) {
                    totalProduct = snapshot.hasData ? snapshot.data.length : 0;
                    return snapshot.hasData
                        ? GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 30,
                              childAspectRatio: 3 / 4.6,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data[index],
                                child: ProductItem(
                                    scaffoldKey: _scaffoldKey,
                                    productProvider: _productProvider),
                              );
                            },
                          )
                        : MyCircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
