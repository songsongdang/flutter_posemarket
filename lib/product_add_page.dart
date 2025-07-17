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

  // assets 폴더 이미지 선택 다이얼로그
  final List<String> imageAssets = [
    'assets/bike.png',
    'assets/massageball.png',
    'assets/pomroller.png',
    'assets/yogaclothes.png',
    'assets/rope.png',
    'assets/yogablock.png',
    'assets/socks.png',
    'assets/sportbra.png',

    // ...더 추가 가능
  ];

  Future<void> pickAssetImage(BuildContext context) async {
    final selected = await showDialog<String>(
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
    }
    return Text('이미지를 선택하세요.');
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
                decoration: InputDecoration(labelText: '상품 가격'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty
                    ? '필수 입력'
                    : (int.tryParse(v) == null ? '숫자만 입력' : null),
                onChanged: (v) => price = v,
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
                      id: DateTime.now().toString(),
                      name: name,
                      price: int.parse(price),
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
