import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/notification/page/notification_page.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'ratings'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 20, color: colorScheme(context).onSurface),
                  ),
                  const Spacer(),
                  // GestureDetector(
                  //       onTap: () => context.pushNamed(AppRoute.cartPage),
                  //       child: SvgPicture.asset(AppIcons.cartIcon)),
                  //   const SizedBox(width: 15),
                  GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const NotificationPage(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      // onTap: () =>
                      //     context.pushNamed(AppRoute.notificationPage),
                      child: SvgPicture.asset(AppIcons.notiIcon)),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: colorScheme(context).onPrimary,
                        border:
                            Border.all(color: colorScheme(context).outline)),
                    padding: const EdgeInsets.all(16),
                    // child: ListView.builder(
                    //   itemBuilder: (context, index) {
                    //     return ;
                    //   },
                    // ),
                    child: ListView.builder(
                      itemCount: 6, // To display 6 list items
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: colorScheme(context).onPrimary,
                              border: Border.all(
                                color: colorScheme(context).outline,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 30,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[200],
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[200],
                                        child: const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "Elaenor Park",
                                    style: textTheme(context)
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    "Nov 7,2023",
                                    style: textTheme(context)
                                        .labelSmall
                                        ?.copyWith(
                                            color: colorScheme(context)
                                                .outline
                                                .withOpacity(0.7),
                                            fontSize: 10),
                                  ),
                                  trailing: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, size: 15),
                                      Icon(Icons.star, size: 15),
                                      Icon(Icons.star, size: 15),
                                      Icon(Icons.star, size: 15),
                                      Icon(Icons.star, size: 15),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Lorem Ipsum has been the industry's standard dummy text ever since Lorem Ipsum has been the industry's standard.",
                                  style: textTheme(context).bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
