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
  // 사용자 등록 상품만 표시 (기본 상품 없음)
  List<Product> products = [];

  // 장바구니 데이터
  Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PoseMarket'),
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
      body: Column(
        children: [
          // 2025년 세일 배너
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(
              'assets/sale.2.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          // 상품 리스트
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      '등록된 상품이 없습니다.\n오른쪽 아래 + 버튼으로 상품을 등록해보세요!',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: p,
                                  onAddToCart: (count) {
                                    setState(() {
                                      cart[p.id] = (cart[p.id] ?? 0) + count;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  p.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${p.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        p.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
