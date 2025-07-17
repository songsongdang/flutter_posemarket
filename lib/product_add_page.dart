import 'package:flutter/material.dart';
import 'product.dart';

class ProductAddPage extends StatefulWidget {
  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String price = '';
  String desc = '';
  String? assetImagePath;

  // 가격 필드 전용 컨트롤러와 커서 위치 상태
  final TextEditingController priceController = TextEditingController();

  final List<String> imageAssets = [
    'assets/bike.png',
    'assets/massageball.png',
    'assets/pomroller.png',
    'assets/yogaclothes.png',
    'assets/rope.png',
    'assets/yogablock.png',
    'assets/socks.png',
    'assets/sportbra.png',
  ];

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  Future pickAssetImage(BuildContext context) async {
    final selected = await showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('이미지 선택'),
        children: imageAssets
            .map(
              (asset) => SimpleDialogOption(
                child: Image.asset(asset, height: 60),
                onPressed: () => Navigator.pop(ctx, asset),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      setState(() {
        assetImagePath = selected;
      });
    }
  }

  Widget _buildImagePreview() {
    if (assetImagePath != null) {
      return Image.asset(assetImagePath!, height: 100);
    } else {
      return Text('이미지를 선택하세요.');
    }
  }

  // 숫자만 추출하는 함수
  String _unformatNumber(String input) =>
      input.replaceAll(RegExp('[^0-9]'), '');

  // 입력값을 3자리마다 콤마가 찍히도록 포맷팅
  String _formatNumber(String input) {
    if (input.isEmpty) return '';
    final n = int.parse(input);
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 등록'), leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () => pickAssetImage(context),
                child: Text(assetImagePath != null ? '이미지 선택됨' : '이미지 선택'),
              ),
              _buildImagePreview(),
              TextFormField(
                decoration: InputDecoration(labelText: '상품 이름'),
                validator: (v) => v == null || v.isEmpty ? '필수 입력' : null,
                onChanged: (v) => name = v,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: '상품 가격'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final raw = _unformatNumber(v ?? '');
                  if (raw.isEmpty) return '필수 입력';
                  if (int.tryParse(raw) == null) return '숫자만 입력';
                  return null;
                },
                onChanged: (String v) {
                  // 숫자만 추출
                  String onlyNumber = _unformatNumber(v);
                  if (onlyNumber.isEmpty) {
                    price = '';
                    priceController.text = '';
                    priceController.selection = TextSelection.collapsed(
                      offset: 0,
                    );
                    return;
                  }
                  // 3자리마다 콤마 추가
                  String formatted = _formatNumber(onlyNumber);
                  // price에 숫자만 저장(나중에 int로 변환)
                  price = onlyNumber;
                  // 커서 위치를 끝으로 이동
                  priceController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '상품 설명'),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? '필수 입력' : null,
                onChanged: (v) => desc = v,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      assetImagePath != null) {
                    final newProduct = Product(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      name: name,
                      price: int.parse(price), // 콤마 없는 숫자만 저장
                      imageUrl: assetImagePath!,
                      description: desc,
                    );
                    Navigator.pop(context, newProduct);
                  } else if (assetImagePath == null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('이미지를 선택하세요.')));
                  }
                },
                child: Text('등록하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
