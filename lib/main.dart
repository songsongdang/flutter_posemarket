import 'package:flutter/material.dart';
import 'product.dart';
import 'product_list_page.dart';
import 'category_page.dart';
import 'mypage.dart';

// main.dart
void main() {
  runApp(PoseMarketApp());
}

class PoseMarketApp extends StatelessWidget {
  const PoseMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POSEMARKET',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  // 상품 및 장바구니 상태 - 프로젝트 전체 공유
  final List<Product> defaultProducts = [
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
    Product(
      id: '5',
      name: '여성 스포츠 브라',
      price: 35000,
      imageUrl: 'assets/sportbra.png',
      description: '운동 필수품, 상체를 단단히 잡아주는 스포츠 브라',
    ),
    Product(
      id: '6',
      name: '여성 요가 양말',
      price: 25000,
      imageUrl: 'assets/socks.png',
      description: '색깔별로 골라신는 요가양말, 미끄럼 방지 기술 적용',
    ),
  ];

  final List<Product> userProducts = [];
  final Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    final allProducts = [...defaultProducts, ...userProducts];
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          ProductListPage(
            defaultProducts: defaultProducts,
            userProducts: userProducts,
            cart: cart,
          ),
          CategoryPage(
            defaultProducts: defaultProducts,
            userProducts: userProducts,
            cart: cart,
          ),
          MyPage(cart: cart, allProducts: allProducts),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (idx) => setState(() => currentIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '카테고리'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
