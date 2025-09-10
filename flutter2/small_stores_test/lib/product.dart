import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:small_stores_test/editproduct.dart';
import 'package:small_stores_test/showstoredata.dart';
import 'apiService/api_service.dart';
import 'apiService/favorit_api.dart';
import 'apiService/product_api.dart';
import 'apiService/store_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'store.dart';
import 'style.dart';
import 'variables.dart';

class Product extends StatefulWidget {
  final int product_id;
  final int class_id;
  final User user;

  const Product({
    Key? key,
    required this.product_id,
    required this.user,
    required this.class_id,
  }) : super(key: key);

  @override
  _Product createState() => _Product();
}

class _Product extends State<Product> {
  ProductModel? _product;
  bool showOptions = false;

  // دالة لعرض تأكيد الحذف بخطوتين
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // الخطوة الأولى: تأكيد الحذف
    bool firstConfirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تأكيد الحذف',style: style_text_titel,),
        content: Text('هل تريد حذف هذا المنتج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء',style: style_text_button_normal_2(color_Secondary),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('نعم', style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (firstConfirm == true) {
      // الخطوة الثانية: التأكيد النهائي
      bool finalConfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('تأكيد نهائي',style: style_text_titel,),
          content: Text('هل أنت متأكد من أنك تريد حذف هذا المنتج؟ لا يمكن التراجع عن هذه العملية.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('إلغاء',style: style_text_button_normal_2(color_Secondary),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('تأكيد الحذف', style: style_text_button_normal_red),
            ),
          ],
        ),
      );

      if (finalConfirm == true) {
        _deleteProduct();
      }
    }
  }

  // دالة حذف المنتج
  Future<void> _deleteProduct() async {
    try {
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      await productApi.deleteProduct(_product!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف المنتج بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف المنتج: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Center(
          child: ProductBody(
            product_id: widget.product_id,
            onProductLoaded: (product) {
              setState(() {
                _product = product;
              });
            },
            canEditAvailability: true,
            user: widget.user,
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_product != null && showOptions) ...[
            FloatingActionButton(
              heroTag: "editBtn",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProduct(
                      product: _product!,
                      user: widget.user,
                      class_id: widget.class_id,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.edit, color: color_main),
            ),
            SizedBox(height: 10),

            FloatingActionButton(
              heroTag: "deleteBtn",
              onPressed: () {
                setState(() {
                  showOptions = false;
                });
                _showDeleteConfirmation(context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.delete, color: Colors.red),
            ),
            SizedBox(height: 10),
          ],

          FloatingActionButton(
            heroTag: "moreBtn",
            onPressed: () {
              setState(() {
                showOptions = !showOptions;
              });
            },
            backgroundColor: color_main,
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProductBody extends StatefulWidget {
  final int product_id;
  final Function(ProductModel)? onProductLoaded;
  final bool canEditAvailability;
  final int likesCount;
  final Function? onFavoriteChanged;
  final User user;

  ProductBody({
    required this.product_id,
    this.onProductLoaded,
    this.canEditAvailability = false,
    this.likesCount = 0,
    this.onFavoriteChanged,
    required this.user
  });

  @override
  _ProductBody createState() => _ProductBody();
}

class _ProductBody extends State<ProductBody> {
  final TextEditingController _productStaiteController = TextEditingController();

  String _getImageUrl(String url) {
    if (url.isEmpty) return '';

    print('Original URL: $url');

    if (kIsWeb) {
      // للويب: خلّي 127.0.0.1 كما هو
      return url.replaceFirst('localhost', '127.0.0.1');
    } else {
      // للإموليتور
      return url.replaceFirst('127.0.0.1', '127.0.0.1');
    }
  }

  Future<void> _checkImageConnection() async {
    final imageUrl = _getImageUrl(_product.product_photo_1);
    print('Checking image URL: $imageUrl');

    try {
      final response = await http.head(Uri.parse(imageUrl));
      print('Image response status: ${response.statusCode}');
      print('Image response headers: ${response.headers}');
    } catch (e) {
      print('Image connection error: $e');
    }
  }


  late ProductModel _product;
  late String _typeName = '';
  late String _storeName = '';
  bool _isLoading = true;
  int _productAvailable = 0;
  int _likesCount = 0;
  late String _storePhoto = '';

  final ProductApi _productApi =
  ProductApi(apiService: ApiService(client: http.Client()));

  @override
  void initState() {
    super.initState();
    fetchProduct().then((_) {
      if (_product.product_photo_1.isNotEmpty) {
        _checkImageConnection();
      }
    });
  }


  @override
  void didUpdateWidget(ProductBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.likesCount != widget.likesCount) {
      setState(() {
        _likesCount = widget.likesCount;
      });
    }
  }

  Future<void> fetchProduct() async {
    try {
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));

      final fetchedProduct = await productApi.getProduct(widget.product_id);
      print('Product photo URL: ${fetchedProduct.product_photo_1}');
      //print('Store photo URL: ${fetchedStore.store_photo}');

      if (widget.onProductLoaded != null) {
        widget.onProductLoaded!(fetchedProduct);
      }

      final fetchedType = await typeApi.getType(fetchedProduct.type_id);
      final fetchedStore = await storeApi.getStore(fetchedProduct.store_id);

      setState(() {
        _product = fetchedProduct;
        _typeName = fetchedType.type_name;
        _storeName = fetchedStore.store_name;
        _storePhoto = fetchedStore.store_photo; // 👈 أضف هذا السطر
        _productAvailable = _product.product_available;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ أثناء جلب المنتج أو المتجر أو النوع: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAvailability(bool newValue) async {
    try {
      setState(() {
        _product.product_available = newValue ? 1 : 0;
      });

      await _productApi.updateProduct(
        _product.id,
        product_available: newValue ? 1 : 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newValue ? 'تم تفعيل توفر المنتج' : 'تم إلغاء توفر المنتج'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _product.product_available = newValue ? 0 : 1; // ترجيع القيمة القديمة عند الخطأ
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء التحديث'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final productImageUrl = _getImageUrl(_product.product_photo_1);
    print('Building with product image: $productImageUrl');

    return SingleChildScrollView(
        child:Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          CachedNetworkImage(
            imageUrl: _getImageUrl(_product.product_photo_1),
            imageBuilder: (context, imageProvider) => Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              width: double.infinity,
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 50),
                  SizedBox(height: 10),
                  Text('فشل تحميل الصورة'),
                  SizedBox(height: 10),
                  Text(
                    'URL: ${_getImageUrl(_product.product_photo_1)}',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          // اسم المنتج والسعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _product.product_name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${_product.product_price} \$',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color_main,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // معلومات المتجر (صورة + اسم + انتقال لواجهة المتجر)
          GestureDetector(
            onTap: () async {
              try {
                final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
                final store = await storeApi.getStore(_product.store_id);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowStoreData(
                      store: store,
                      user: widget.user,
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('فشل تحميل بيانات المتجر')),
                );
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: _storePhoto.isNotEmpty
                      ? NetworkImage(_storePhoto)
                      : AssetImage("assets/default_store.png") as ImageProvider,
                  backgroundColor: Colors.grey[200],
                  onBackgroundImageError: (exception, stackTrace) {
                    // يمكنك إضافة handle error هنا
                  },
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _storeName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // عدد المعجبين
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: 24),
              SizedBox(width: 10),
              Text(
                'عدد المحبين: $_likesCount',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          // نوع المنتج
          Row(
            children: [
              Icon(Icons.category, color: color_main, size: 24),
              SizedBox(width: 10),
              Text(
                '$a_product_type_s: $_typeName',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // وصف المنتج
          Text(
            '$a_product_note_s:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _product.product_description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),

          // حالة التوفر
          Row(
            children: [
              Icon(
                _product.product_available == 1
                    ? Icons.check_circle
                    : Icons.cancel,
                color: _product.product_available == 1
                    ? Colors.green
                    : Colors.red,
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                'حالة التوفر:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(width: 8),
              Text(
                _product.product_available == 1 ? "متوفر" : "غير متوفر",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _product.product_available == 1
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              if (widget.canEditAvailability) ...[
                SizedBox(width: 16),
                Switch(
                  value: _product.product_available == 1,
                  onChanged: _updateAvailability,
                  activeColor: color_main,
                ),
              ],
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    )
    );
  }
}