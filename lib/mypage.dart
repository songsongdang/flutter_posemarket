import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'product.dart';

class MyPage extends StatelessWidget {
  final Map<String, int> cart;
  final List<Product> allProducts;
  final bool isLoggedIn;

  const MyPage({
    super.key,
    required this.cart,
    required this.allProducts,
    this.isLoggedIn = false, // 필요시 로그인 상태 반영
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지')),
      body: ListView(
        children: [
          SizedBox(height: 24),
          _buildMenuButton(
            context,
            icon: Icons.shopping_cart,
            label: '장바구니',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cart: cart, products: allProducts),
                ),
              );
            },
          ),
          _buildMenuButton(
            context,
            icon: Icons.receipt_long,
            label: '구매내역',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DummyPage(title: '구매내역')),
              );
            },
          ),
          _buildMenuButton(
            context,
            icon: Icons.local_shipping,
            label: '배송내역',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DummyPage(title: '배송내역')),
              );
            },
          ),
          Divider(height: 40),
          isLoggedIn
              ? _buildMenuButton(
                  context,
                  icon: Icons.logout,
                  label: '로그아웃',
                  onTap: () {
                    // 로그아웃 로직 작성
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('로그아웃 되었습니다.')));
                  },
                )
              : _buildMenuButton(
                  context,
                  icon: Icons.login,
                  label: '로그인',
                  onTap: () {
                    // 로그인 페이지로 이동 또는 로그인 로직
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('로그인 기능을 구현하세요.')));
                  },
                ),
          _buildMenuButton(
            context,
            icon: Icons.settings,
            label: '설정',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DummyPage(title: '설정')),
              );
            },
          ),
          _buildMenuButton(
            context,
            icon: Icons.support_agent,
            label: '고객지원',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DummyPage(title: '고객지원')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple, size: 30),
      title: Text(label, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// 임시 더미 페이지
class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title 페이지는 준비중입니다.')),
    );
  }
}
