import 'package:flutter/material.dart';
import 'product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Function(int) onAddToCart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    required Null Function(dynamic editedProduct) onEdit,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(p.name), leading: BackButton()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(p.imageUrl, height: 200),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(p.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (count > 1) count--;
                    });
                  },
                ),
                Text('$count'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (count < 99) count++;
                    });
                  },
                ),
              ],
            ),
            Text(
              '총 가격: ${(p.price * count).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
            ),
            ElevatedButton(
              child: Text('장바구니에 담기'),
              onPressed: () {
                widget.onAddToCart(count);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${p.name} $count개가 장바구니에 담겼습니다.')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
