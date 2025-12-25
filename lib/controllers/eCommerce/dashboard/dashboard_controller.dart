import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_grocery/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_grocery/models/eCommerce/dashboard/dashboard.dart';
import 'package:ready_grocery/models/eCommerce/product/product.dart';
import 'package:ready_grocery/services/eCommerce/dashboard_service/dashboard_service.dart';
import 'package:ready_grocery/utils/request_handler.dart';

final dashboardControllerProvider = StateNotifierProvider.autoDispose<
    DashboardController, AsyncValue<Dashboard>>((ref) {
  final controller = DashboardController(ref);
  controller.getDashboardData();
  return controller;
});

class DashboardController extends StateNotifier<AsyncValue<Dashboard>> {
  final Ref ref;
  DashboardController(this.ref) : super(const AsyncLoading());

  Future<void> getDashboardData() async {
    try {
      final response =
          await ref.read(dashboardServiceProvider).getDashboardData();
      final data = response.data['data'];
      state = AsyncData(Dashboard.fromMap(data));
    } catch (error, stackTrace) {
      debugPrint(error.toString());

      state = AsyncError(
        error is DioException ? ApiInterceptors.handleError(error) : error,
        stackTrace,
      );
      throw Exception(stackTrace);
    }
  }

  Future<void> toggleFavourite(Product product,
      {bool isJustForYouProduct = false}) async {
    final previousState = state;
    try {
      state = state.whenData((dashboard) {
        if (isJustForYouProduct) {
          final update = dashboard.justForYou.products.map((p) {
            if (p.id == product.id) {
              return p.copyWith(isFavorite: !p.isFavorite);
            }
            return p;
          }).toList();
          return dashboard.copyWith(
              justForYou: dashboard.justForYou.copyWith(products: update));
        }
        final update = dashboard.popularProducts.map((p) {
          if (p.id == product.id) {
            return p.copyWith(isFavorite: !p.isFavorite);
          }
          return p;
        }).toList();
        return dashboard.copyWith(popularProducts: update);
      });
      await ref
          .read(productControllerProvider.notifier)
          .favoriteProductAddRemove(
            productId: product.id,
          );
    } catch (e) {
      state = previousState;
    }
  }
}
