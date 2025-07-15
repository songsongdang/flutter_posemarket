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
  // 4개 기본 인기상품
  List<Product> defaultProducts = [
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
  List<Product> userProducts = [];
  Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    final popularProducts = defaultProducts.take(4).toList();
    final allProducts = [...defaultProducts, ...userProducts];

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
                      CartPage(cart: cart, products: allProducts),
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
            // 상단 배너
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
            // 인기상품 카드 4개 진열 (2열 그리드)
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
                      await Navigator.push(
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
                                defaultProducts[index] = editedProduct;
                              });
                            },
                          ),
                        ),
                      );
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
            // 사용자 등록 상품
            if (userProducts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
                child: Text(
                  '새로 등록한 상품',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (userProducts.isNotEmpty)
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
                  itemCount: userProducts.length,
                  itemBuilder: (context, index) {
                    final p = userProducts[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
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
                                  userProducts[index] = editedProduct;
                                });
                              },
                            ),
                          ),
                        );
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
            MaterialPageRoute(builder: (context) => ProductAddPage()),
          );
          if (newProduct != null) {
            setState(() {
              userProducts.add(newProduct);
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
