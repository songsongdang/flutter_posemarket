// product_list_page.dart
import 'package:flutter/material.dart';
import 'product.dart';
import 'product_detail_page.dart';
import 'product_add_page.dart';
import 'cart_page.dart';

// 검색 Delegate 클래스
class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> allProducts;

  ProductSearchDelegate(this.allProducts);

  @override
  String? get searchFieldLabel => '상품 이름으로 검색';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (results.isEmpty) {
      return Center(child: Text('검색 결과가 없습니다.'));
    }
    return ListView(
      children: results.map((product) {
        return ListTile(
          leading: Image.asset(product.imageUrl, width: 48, height: 48),
          title: Text(product.name),
          subtitle: Text('${product.price}원'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  product: product,
                  onAddToCart: (count) {},
                  onEdit: (_) {},
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : allProducts
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return ListView(
      children: suggestions.map((product) {
        return ListTile(
          leading: Image.asset(product.imageUrl, width: 40, height: 40),
          title: Text(product.name),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  final List<Product> defaultProducts;
  final List<Product> userProducts;
  final Map<String, int> cart;

  const ProductListPage({
    Key? key,
    required this.defaultProducts,
    required this.userProducts,
    required this.cart,
  }) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    final popularProducts = widget.defaultProducts.take(6).toList();
    final allProducts = [...widget.defaultProducts, ...widget.userProducts];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POSEMARKET',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final allProducts = [
                ...widget.defaultProducts,
                ...widget.userProducts,
              ];
              await showSearch(
                context: context,
                delegate: ProductSearchDelegate(allProducts),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CartPage(cart: widget.cart, products: allProducts),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  'assets/summersale.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                '인기상품',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: popularProducts.length,
                itemBuilder: (context, index) {
                  final p = popularProducts[index];
                  return GestureDetector(
                    onTap: () async {
                      final updatedProduct = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            product: p,
                            onAddToCart: (count) {
                              setState(() {
                                widget.cart[p.id] =
                                    (widget.cart[p.id] ?? 0) + count;
                              });
                            },
                            onEdit: (editedProduct) {
                              setState(() {
                                widget.defaultProducts[index] = editedProduct;
                              });
                            },
                          ),
                        ),
                      );
                      if (updatedProduct != null) {
                        setState(() {
                          widget.defaultProducts[index] = updatedProduct;
                        });
                      }
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.asset(p.imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${p.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.userProducts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
                child: Text(
                  '신상품',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (widget.userProducts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: widget.userProducts.length,
                  itemBuilder: (context, index) {
                    final p = widget.userProducts[index];
                    return GestureDetector(
                      onTap: () async {
                        final updatedProduct = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              product: p,
                              onAddToCart: (count) {
                                setState(() {
                                  widget.cart[p.id] =
                                      (widget.cart[p.id] ?? 0) + count;
                                });
                              },
                              onEdit: (editedProduct) {
                                setState(() {
                                  widget.userProducts[index] = editedProduct;
                                });
                              },
                            ),
                          ),
                        );
                        if (updatedProduct != null) {
                          setState(() {
                            widget.userProducts[index] = updatedProduct;
                          });
                        }
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  p.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${p.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductAddPage()),
          );
          if (newProduct != null) {
            setState(() {
              widget.userProducts.add(newProduct);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
