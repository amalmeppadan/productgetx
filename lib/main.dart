import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx22/methods/Products.dart';
import 'package:getx22/methods/Resp.dart';

import 'package:http/http.dart' as http;


class ProductController extends GetxController {
  var productList = [].obs;



  @override
  void onInit() {
    super.onInit();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      var jsondata=jsonDecode(response.body.toString());
      var data=Resp.fromJson(jsondata);
      var list=data.products;
      productList.addAll(list as Iterable);
      update();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
class UserListScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product List'),
      ),
      body: Obx(
            () {
          if (productController.productList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: productController.productList.length,
              itemBuilder: (BuildContext context, int index) {
                final product = productController.productList[index] as Products;
                return Container(
                  color: Colors.greenAccent,
                    height: 230,
                    child: Column(children: [

                    Text('${product.id}'),
                Text('${product.title}'),
                 Text('${product.category}'),
                 // Text('${product.images}'),
                ],
                ),
                );
              },
            );
          }
        },
      ),
    );
  }
}



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: Home(),
    );
  }
}
class Home extends StatelessWidget {
   Home({super.key});
  final ProductController _controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    _controller.fetchProduct();
    return Scaffold(

body: UserListScreen(),
    );
  }
}

