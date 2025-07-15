import 'package:flutter/material.dart';
import 'product.dart';

class CartPage extends StatefulWidget {
  final Map<String, int> cart;
  final List<Product> products;

  const CartPage({super.key, required this.cart, required this.products});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final items = widget.cart.entries.where((e) => e.value > 0).toList();

    // 총 금액 계산
    int totalPrice = items.fold(0, (sum, e) {
      final p = widget.products.firstWhere(
        (prod) => prod.id == e.key,
        orElse: () =>
            Product(id: '', name: '', price: 0, imageUrl: '', description: ''),
      );
      return sum + (p.price * e.value);
    });

    return Scaffold(
      appBar: AppBar(title: Text('장바구니')),
      body: items.isEmpty
          ? Center(child: Text('장바구니가 비어있습니다.'))
          : ListView(
              children: items.map((e) {
                final p = widget.products.firstWhere(
                  (prod) => prod.id == e.key,
                  orElse: () => Product(
                    id: '',
                    name: '',
                    price: 0,
                    imageUrl: '',
                    description: '',
                  ),
                );
                return ListTile(
                  leading: p.imageUrl.isNotEmpty
                      ? Image.asset(p.imageUrl, width: 50, height: 50)
                      : SizedBox(width: 50, height: 50),
                  title: Text(p.name.isNotEmpty ? p.name : '알 수 없는 상품'),
                  subtitle: Text(
                    '${e.value}개  /  ${(p.price * e.value).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        widget.cart.remove(e.key);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
      bottomNavigationBar: items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 총 금액 표시
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총 금액',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('구매가 완료되었습니다!')));
                      setState(() {
                        widget.cart.clear();
                      });
                    },
                    child: Text('구매하기'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
