import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_grocery/models/eCommerce/flash_sales_list_model/data.dart';
import 'package:ready_grocery/models/eCommerce/flash_sales_list_model/running_flash_sale.dart';
import 'package:ready_grocery/models/eCommerce/product/product.dart';
import 'package:ready_grocery/services/eCommerce/flash_sales/flash_sales_service.dart';

final flashSalesListControllerProvider =
    StateNotifierProvider<FlashSalesListController, bool>((ref) {
  return FlashSalesListController(ref);
});

class FlashSalesListController extends StateNotifier<bool> {
  final Ref ref;
  FlashSalesListController(this.ref) : super(false) {
    getFlashSalesList();
  }

  List<RunningFlashSale> runningFlashSales = [];
  List<RunningFlashSale> inComingFlashSales = [];

  Future<void> getFlashSalesList() async {
    try {
      state = true;
      final response =
          await ref.read(flashSalesServiceProvider).getFlashSalesList();

      final data = response.data['data'];
      if (data != null && data is Map<String, dynamic>) {
        Data saleData = Data.fromMap(data);
        runningFlashSales = saleData.runningFlashSale;
        inComingFlashSales = saleData.incomingFlashSale;
      } else {
        runningFlashSales = [];
        inComingFlashSales = [];
      }

      state = false;
    } catch (e, stk) {
      state = false;
      debugPrint(e.toString());
      debugPrint(stk.toString());
    }
  }
}

final flashSaleDetailsControllerProvider =
    StateNotifierProvider<FlashSalesDetailsController, bool>((ref) {
  return FlashSalesDetailsController(ref);
});

class FlashSalesDetailsController extends StateNotifier<bool> {
  final Ref ref;
  FlashSalesDetailsController(this.ref) : super(false);
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> getFlashSalesDetails({required int id}) async {
    try {
      state = true;
      final response =
          await ref.read(flashSalesServiceProvider).getFlashSalesDetail(id: id);
      final List<dynamic> data = response.data['data']["products"];
      _products = data.map((product) => Product.fromMap(product)).toList();
      state = false;
    } catch (e, stk) {
      state = false;
      debugPrint(e.toString());
      debugPrint(stk.toString());
    }
  }
}
