import 'package:flutter/material.dart';
import 'product.dart';
import 'product_detail_page.dart';

class CategoryPage extends StatefulWidget {
  final List<Product> defaultProducts;
  final List<Product> userProducts;
  final Map<String, int> cart;

  const CategoryPage({
    Key? key,
    required this.defaultProducts,
    required this.userProducts,
    required this.cart,
  }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedCategory = '의류';
  String sortType = '인기순';

  @override
  Widget build(BuildContext context) {
    final allProducts = [...widget.defaultProducts, ...widget.userProducts];

    // 의류/기구 분류
    final clothing = allProducts
        .where(
          (p) =>
              p.name.contains('요가복') ||
              p.name.contains('요가 양말') ||
              p.name.contains('요가양말') ||
              p.name.contains('스포츠 브라'),
        )
        .toList();
    final equipment = allProducts.where((p) => !clothing.contains(p)).toList();

    List<Product> filtered = selectedCategory == '의류' ? clothing : equipment;

    // 정렬 옵션 적용
    if (sortType == '가격오름차순') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortType == '가격내림차순') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else {
      filtered.sort((a, b) => a.id.compareTo(b.id));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('정렬: '),
                DropdownButton<String>(
                  value: sortType,
                  items: ['인기순', '가격오름차순', '가격내림차순']
                      .map((v) => DropdownMenuItem(child: Text(v), value: v))
                      .toList(),
                  onChanged: (v) => setState(() => sortType = v!),
                ),
              ],
            ),
          ),
        ),
        elevation: 1,
      ),
      body: Row(
        children: [
          // 좌측: 카테고리 메뉴
          Container(
            width: 110,
            color: Colors.grey[100],
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    '의류',
                    style: TextStyle(
                      fontWeight: selectedCategory == '의류'
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                  selected: selectedCategory == '의류',
                  onTap: () => setState(() {
                    selectedCategory = '의류';
                  }),
                ),
                ListTile(
                  title: Text(
                    '기구',
                    style: TextStyle(
                      fontWeight: selectedCategory == '기구'
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                  selected: selectedCategory == '기구',
                  onTap: () => setState(() {
                    selectedCategory = '기구';
                  }),
                ),
              ],
            ),
          ),
          // 우측: 상품 리스트
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('상품이 없습니다.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final p = filtered[i];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
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
                                onEdit: (_) {},
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
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
        ],
      ),
    );
  }
}
