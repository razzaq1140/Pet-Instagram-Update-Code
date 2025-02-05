import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_shimmer.dart';
import '../../home/model/home_model.dart';

class RecipeViewDetailsWidget extends StatelessWidget {
  final int index;
  final PostsModel post;

  const RecipeViewDetailsWidget(
      {super.key, required this.index, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: colorScheme(context).outline.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image on the left
          CachedNetworkImage(
            imageUrl: post.userImage,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => CustomShimmer(
              height: 60,
              width: 60,
              radius: 10,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 16),

          // Text and content in the middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {
              // Trigger the dialog with the current post data
              _showRecipeDialog(context, post);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  colorScheme(context).primary, // Button background color
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'view_detail'.tr(),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

//  // Show recipe dialog specific to this widget
  void _showRecipeDialog(BuildContext context, PostsModel post) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preparation steps',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close,
                                color: colorScheme(context).error),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildStep(
                        '1. Cook the protein:',
                        'Heat the olive oil in a large pan over medium heat. Add the ground turkey or chicken and cook until browned, breaking it up with a spoon as it cooks (about 8–10 minutes).',
                      ),
                      const SizedBox(height: 8),
                      _buildStep(
                        '2. Cook the grains:',
                        'While the protein is cooking, prepare the brown rice or quinoa according to the package instructions.',
                      ),
                      const SizedBox(height: 8),
                      _buildStep(
                        '3. Add vegetables to the pan:',
                        'Stir in the carrots and peas into the pan with the cooked meat. Sauté the vegetables for 5 minutes until softened.',
                      ),
                      const SizedBox(height: 8),
                      _buildStep(
                        '4. Combine the grains and meat:',
                        'Once the rice or quinoa is cooked, add it to the pan with the meat and vegetables. Mix thoroughly.',
                      ),
                      const SizedBox(height: 8),
                      _buildStep(
                        '5. Add spinach:',
                        'Stir in the chopped spinach and cook for another 2–3 minutes until the spinach wilts.',
                      ),
                      const SizedBox(height: 8),
                      _buildStep(
                        '6. Cool and serve:',
                        'Allow the mixture to cool completely before serving it to your dog. Store any leftovers in an airtight container in the fridge for up to 3 days.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(description),
      ],
    );
  }
}
