import 'package:flutter/material.dart';
import 'product.dart';

class CartPage extends StatefulWidget {
  final Map<String, int> cart;
  final List<Product> products;

  const CartPage({super.key, required this.cart, required this.products});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 선택된 상품 ID 집합
  Set<String> selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.entries.where((e) => e.value > 0).toList();

    // 총 금액 (선택된 것만 반영)
    int selectedTotal = items.fold(0, (sum, e) {
      if (!selectedIds.contains(e.key)) return sum;
      final p = widget.products.firstWhere(
        (prod) => prod.id == e.key,
        orElse: () =>
            Product(id: '', name: '', price: 0, imageUrl: '', description: ''),
      );
      return sum + (p.price * e.value);
    });

    int totalPrice = items.fold(0, (sum, e) {
      final p = widget.products.firstWhere(
        (prod) => prod.id == e.key,
        orElse: () =>
            Product(id: '', name: '', price: 0, imageUrl: '', description: ''),
      );
      return sum + (p.price * e.value);
    });

    bool allSelected = selectedIds.length == items.length && items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text('장바구니')),
      body: items.isEmpty
          ? Center(child: Text('장바구니가 비어있습니다.'))
          : Column(
              children: [
                // 전체 선택/해제
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: allSelected,
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              selectedIds = items
                                  .map((e) => e.key.toString())
                                  .toSet();
                            } else {
                              selectedIds.clear();
                            }
                          });
                        },
                      ),
                      const Text('전체 선택'),
                      Spacer(),
                      TextButton.icon(
                        onPressed: selectedIds.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  for (final id in selectedIds) {
                                    widget.cart.remove(id);
                                  }
                                  selectedIds.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('선택한 상품이 삭제되었습니다.')),
                                );
                              },
                        icon: Icon(Icons.delete),
                        label: Text('선택 삭제'),
                      ),
                      TextButton.icon(
                        onPressed: items.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  widget.cart.clear();
                                  selectedIds.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('전체 상품이 삭제되었습니다.')),
                                );
                              },
                        icon: Icon(Icons.delete_forever),
                        label: Text('전체 삭제'),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1),
                // 장바구니 상품 리스트
                Expanded(
                  child: ListView(
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
                      final isSelected = selectedIds.contains(e.key);
                      return ListTile(
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                selectedIds.add(e.key);
                              } else {
                                selectedIds.remove(e.key);
                              }
                            });
                          },
                        ),
                        title: Row(
                          children: [
                            if (p.imageUrl.isNotEmpty)
                              Image.asset(p.imageUrl, width: 50, height: 50),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.name.isNotEmpty ? p.name : '알 수 없는 상품',
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${e.value}개 / ${(p.price * e.value).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              widget.cart.remove(e.key);
                              selectedIds.remove(e.key);
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedIds.remove(e.key);
                            } else {
                              selectedIds.add(e.key);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 선택/전체 금액 표시
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedIds.isEmpty ||
                                selectedIds.length == items.length
                            ? '총 금액'
                            : '선택 금액',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${(selectedIds.isEmpty || selectedIds.length == items.length ? totalPrice : selectedTotal).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: items.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('구매가 완료되었습니다!')),
                            );
                            setState(() {
                              widget.cart.clear();
                              selectedIds.clear();
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
