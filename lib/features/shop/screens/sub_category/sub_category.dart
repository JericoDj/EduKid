import 'package:edukid/common/widgets/appbar.dart';
import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/common/widgets/products/product_card/product_card_horizontal.dart';
import 'package:edukid/common/widgets/shimmer/horizontal_product_shimmer.dart';
import 'package:edukid/common/widgets/texts/section_heading.dart';
import 'package:edukid/features/shop/controller/category_controller.dart';
import 'package:edukid/features/shop/screens/all_products/all_products.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/category_model.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({Key? key, required this.category}) : super(key: key);

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    print("Category ID: ${category.id}");
    print("Category Name: ${category.name}");

    return Scaffold(
      appBar: MyAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MySizes.defaultspace),
          child: Column(
            children: [
              /// Banner
              MyRoundedImage(
                  padding: EdgeInsets.all(MySizes.xs),
                  imageUrl: MyImages.onBoardingImage3,
                  applyImageRadius: true),
              SizedBox(height: MySizes.spaceBtwSections),

              /// Sub-Categories
              FutureBuilder(
                  future: controller.getSubCategories(category.id),
                  builder: (context, snapshot) {
                    /// Handle Loader, No Record, or Error Message
                    const loader = MyHorizontalProductShimmer();
                    final widget = MyCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;

                    /// Record found
                    final subCategories = snapshot.data!;

                    print('Sub Categories List:');
                    for (final subCategory in subCategories) {
                      print('Document ID: ${subCategory.id}');
                      print('Category Name: ${subCategory.name}');
                      // Add more properties as needed
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: subCategories.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        final subCategory = subCategories[index];
                        return FutureBuilder(


                          future: controller.getSubCategoryProducts(categoryId: subCategory.id),
                          builder: (context, snapshot) {

                            /// Handle Loader, No Record, or Error Message
                            final widget = MyCloudHelperFunctions.checkMultiRecordState(
                                snapshot: snapshot, loader: loader);
                            if (widget != null) return widget;

                            /// Record found
                            final products = snapshot.data!;


                            return Column(
                              children: [
                                /// HEADING
                                MySectionHeading(
                                  title: subCategory.name,
                                  onPressed: () => Get.to(
                                        () => AllProductsScreen(
                                      title: subCategory.name,
                                      futureMethod: controller.getCategoryProducts(categoryId: subCategory.id, limit: -1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MySizes.spaceBtwItems / 2,
                                ),
                                SizedBox(
                                  height: 110,
                                  child: ListView.separated(
                                    itemCount: products.length,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) => SizedBox(
                                      width: MySizes.spaceBtwItems,
                                    ),
                                    itemBuilder: (context, index) => MyProductCardHorizontal(product: products[index]),
                                  ),
                                ),
                                const SizedBox(height: MySizes.spaceBtwSections,)
                              ],
                            );
                          }
                        );
                      },
                    );
                  })
            ],
          ),
        ), // Padding
      ),
    );
  }
}
