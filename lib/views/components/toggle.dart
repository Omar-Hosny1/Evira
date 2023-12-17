import 'package:evira/controllers/products-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Toggle extends StatelessWidget {
  Toggle({super.key});

  final _isDiscoverSelected =
      ProductController.get.isDiscoverProductsSelected.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 17),
                  backgroundColor:
                      _isDiscoverSelected.isTrue ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  _isDiscoverSelected.value = true;
                  ProductController.get.showAll();
                },
                child: const Text(
                  'Discover',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 17),
                  backgroundColor:
                      _isDiscoverSelected.isFalse ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () {
                  _isDiscoverSelected.value = false;
                  ProductController.get.showForYouProducts();
                },
                child: const Text(
                  'For You',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
