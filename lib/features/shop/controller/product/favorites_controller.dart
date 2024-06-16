import 'dart:convert';

import 'package:edukid/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loaders.dart';
import '../../../../data/repositories.authentication/product/product_repository.dart';
import '../../models/product_model.dart';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find();

  /// Variables
  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  // Method to initialize favorites by reading from storage
  void initFavorites() {
    final json = MyStorageUtility.instance().readData('favorites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(
        storedFavorites.map((key, value) => MapEntry(key, value as bool)),
      );
    }
  }

  bool isFavorite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavoriteProduct(String productId) {
    if (!favorites.containsKey(productId)) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      MyLoaders.customToast(message: 'Product has been added to the Wishlist.');
    } else {
      MyStorageUtility.instance().removeData(productId);
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      MyLoaders.customToast(
        message: 'Product has been removed from the Wishlist.',
      );
    }
  }

  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    MyStorageUtility.instance().saveData('favorites', encodedFavorites);
  }

  Future<List<ProductModel>> favoriteProducts() async {
    return await ProductRepository.instance.getFavoriteProducts(
      favorites.keys.toList(),
    );
  }
}
