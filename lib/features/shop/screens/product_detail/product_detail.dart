import 'package:edukid/common/widgets/appbar.dart';
import 'package:edukid/common/widgets/customShapes/curvedEdges/curved_edges.dart';
import 'package:edukid/common/widgets/customShapes/curvedEdges/curved_edges_widget.dart';
import 'package:edukid/common/widgets/icons/my_circular_icon.dart';
import 'package:edukid/common/widgets/images/my_rounded_image.dart';
import 'package:edukid/common/widgets/products/cart_menu_icons.dart';
import 'package:edukid/common/widgets/texts/section_heading.dart';
import 'package:edukid/features/shop/screens/product_detail/widgets/bottom_add_to_cart_widget.dart';
import 'package:edukid/features/shop/screens/product_detail/widgets/product_attributes.dart';
import 'package:edukid/features/shop/screens/product_detail/widgets/product_image_slider.dart';
import 'package:edukid/features/shop/screens/product_detail/widgets/product_meta_data.dart';
import 'package:edukid/features/shop/screens/product_detail/widgets/rating_share_widget.dart';
import 'package:edukid/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:edukid/utils/constants/colors.dart';
import 'package:edukid/utils/constants/image_strings.dart';
import 'package:edukid/utils/constants/sizes.dart';
import 'package:edukid/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/products/favorite_icon/favorite_icon.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        actions: [

          Row(
            children: [
              MyCartIcon(),
              MyFavoriteIcon(productId: product.id,),
            ],
          )
        ],
      ),
      /// add to cart
      bottomNavigationBar: MyBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// product image slider
            MyProductImageSlider(product: product,),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(

                  right: MySizes.defaultspace,
                  left: MySizes.defaultspace,
                  bottom: MySizes.defaultspace),
              child: Column(
                children: [
                  /// Rating & Share Button
                  MyRatingAndShareWidget(),

                  /// Price, title, Stack,& Brand
                  MyProductMetaData(product: product,),



                  /// Attributes
                  if (product.productType == ProductType.variable.toString())MyProductAttributes(product: product,),
                  if (product.productType == ProductType.variable.toString())SizedBox(height: MySizes.spaceBtwSections,),


                  ///  CheckOut Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text('Check Out'))),

                  SizedBox(height: MySizes.spaceBtwSections,),

                  ///  Description
                  MySectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: MySizes.spaceBtwItems,
                  ),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: 'Less',
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  //
                  // ReadMoreText
                  /// - Reviews
                  const Divider(),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MySectionHeading(
                          title: 'Reviews (199)', showActionButton: false),
                      IconButton(
                          icon: const Icon(Iconsax.arrow_right_3, size: 18),
                          onPressed: () => Get.to (() => ProductReviewsScreen()) ),
                    ],
                  ), // Row
                  const SizedBox(height: MySizes.spaceBtwSections),
                ],
              ),
              // Add more widgets for product details as needed
            ),
          ],
        ),
      ),
    );
  }
}
