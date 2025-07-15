import 'package:flutter/material.dart';
import 'product.dart';
import 'product_detail_page.dart';
import 'product_add_page.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [
    Product(
      id: '1',
      name: '폼롤러',
      price: 15000,
      imageUrl: 'assets/pomroller.png',
      description: '근막 이완에 좋은 폼롤러',
    ),
    Product(
      id: '2',
      name: '마사지볼',
      price: 9000,
      imageUrl: 'assets/massageball.png',
      description: '근육 뭉침 해소에 탁월한 마사지볼',
    ),
    Product(
      id: '3',
      name: '줄넘기',
      price: 12000,
      imageUrl: 'assets/rope.png',
      description: '유산소 운동에 좋은 줄넘기',
    ),
    Product(
      id: '4',
      name: '여성 요가복',
      price: 29000,
      imageUrl: 'assets/yogaclothes.png',
      description: '편안한 착용감의 밝은색 여성 요가복',
    ),
  ];
  Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    final popularProducts = products.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POSEMARKET',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartPage(cart: cart, products: products),
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
            // 인기상품 텍스트
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                '인기상품',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // 인기상품 카드 4개 진열 (2열 그리드, 스크롤 가능)
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
                          builder: (context) => ProductDetailPage(
                            product: p,
                            onAddToCart: (count) {
                              setState(() {
                                cart[p.id] = (cart[p.id] ?? 0) + count;
                              });
                            },
                            onEdit: (editedProduct) {
                              setState(() {
                                products[index] = editedProduct;
                              });
                            },
                          ),
                        ),
                      );
                      if (updatedProduct != null) {
                        setState(() {
                          products[index] = updatedProduct;
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
            SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductAddPage()),
          );
          if (newProduct != null) {
            setState(() {
              products.add(newProduct);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: 0,
        onTap: (idx) {},
      ),
    );
  }
}
