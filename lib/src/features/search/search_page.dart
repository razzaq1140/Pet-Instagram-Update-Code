import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_search_delegate.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/search/explore_page.dart';

import '../../common/constants/app_images.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final List<Map<String, dynamic>> images = [
      {
        'image':
            'https://images.unsplash.com/photo-1450778869180-41d0601e046e?q=80&w=1586&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://images.unsplash.com/photo-1517423568366-8b83523034fd?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://images.unsplash.com/photo-1535554672698-902bc7dfbc50?q=80&w=1454&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?q=80&w=1528&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg?t=st=1726916519~exp=1726920119~hmac=a47d98e71ecb57c70416d25ea8b85ecc3f9c5665a187324529a092597592340a&w=360'
      },
      {
        'image':
            'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg?t=st=1726916519~exp=1726920119~hmac=a47d98e71ecb57c70416d25ea8b85ecc3f9c5665a187324529a092597592340a&w=360'
      },
      {
        'image':
            'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg?t=st=1726916519~exp=1726920119~hmac=a47d98e71ecb57c70416d25ea8b85ecc3f9c5665a187324529a092597592340a&w=360'
      },
      {
        'image':
            'https://images.unsplash.com/photo-1518378188025-22bd89516ee2?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://images.unsplash.com/photo-1450778869180-41d0601e046e?q=80&w=1586&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://images.unsplash.com/photo-1517423568366-8b83523034fd?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {
        'image':
            'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg?t=st=1726916519~exp=1726920119~hmac=a47d98e71ecb57c70416d25ea8b85ecc3f9c5665a187324529a092597592340a&w=360'
      },
    ];

    OverlayEntry? overlayEntry;

    OverlayEntry createOverlayEntry(String imageUrl) {
      return OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Lightened dark background
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Close overlay if background is tapped
                  overlayEntry?.remove();
                  overlayEntry = null;
                },
                child: Container(
                  color: Colors.black.withOpacity(
                      0.4), // Reduced opacity for lighter background
                ),
              ),
            ),
            // Centered image with padding from horizontal edges
            Center(
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20), // Padding for space on both sides
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          tileColor: colorScheme(context).surface,
                          // contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(AppImages.pinkDog),
                          ),
                          title: const Text("Furry Pets"),
                        ),
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                            color: colorScheme(context).surface,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: colorScheme(context).onSurface,
                              ),
                              const Icon(Icons.account_circle_outlined),
                              SvgPicture.asset(AppIcons.sendIcon),
                              const Icon(Icons.more_vert)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: width * 0.85,
                    child: GestureDetector(
                      onTap: () {
                        // Trigger the search delegate when the field is tapped
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                            searchTerms: [
                              'Furry',
                              'Tales',
                              'Pats',
                              'Whiskers',
                              'Snoopy'
                            ],
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        // AbsorbPointer will ensure the text field doesn't take direct input
                        child: CustomTextFormField(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(AppIcons.outlineSearch),
                          ),

                          readOnly: true, // Make sure the field is read-only
                          hint: 'search_hint'.tr(),
                          borderColor:
                              colorScheme(context).outline.withOpacity(0.4),
                          fillColor: colorScheme(context).surface,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: SvgPicture.asset(AppIcons.filter),
                          ),
                          suffixConstraints:
                              const BoxConstraints(minHeight: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: MasonryGridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: images.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPressStart: (details) {
                        // Close any previous overlay before showing a new one
                        if (overlayEntry != null) {
                          overlayEntry?.remove();
                          overlayEntry = null;
                        }

                        // Show overlay on long press start
                        overlayEntry =
                            createOverlayEntry(images[index]['image']);
                        Overlay.of(context).insert(overlayEntry!);
                      },
                      onLongPressEnd: (details) {
                        // Remove overlay on long press end
                        overlayEntry?.remove();
                        overlayEntry = null;
                      },
                      onTap: () {
                        // Combine GoRouter push with PersistentNavBarNavigator to navigate with parameters
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ExplorePage(
                            queryParameters: {
                              'imageUrl': images[index][
                                  'image'], // Pass the image URL as a query parameter
                            },
                          ),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: images[index]['image'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
