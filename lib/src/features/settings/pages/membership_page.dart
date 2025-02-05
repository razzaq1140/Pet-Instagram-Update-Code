import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_3d/gallery3d.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/widget/custom_button.dart';
import '/src/features/settings/controller/settings_controller.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../../router/routes.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final Gallery3DController _controller = Gallery3DController(
    itemCount: 3,
    autoLoop: true,
    delayTime: 5000,
  );

  List<dynamic> memberships = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsController>(context, listen: false)
          .fetchMemberships();
    });
  }

  int? selectedMembershipId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "membership".tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                color: colorScheme(context).onSurface,
              ),
        ),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              )
            : null,
        actions: [
          TextButton(
            onPressed: () {
              MyAppRouter.clearAndNavigate(context, AppRoute.navigationBar);
            },
            child: Text(
              'skip'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme(context).onSurface.withOpacity(0.5),
                  ),
            ),
          ),
        ],
      ),
      body: Consumer<SettingsController>(builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.memberships.isEmpty) {
          return const Center(child: Text('No memberships available.'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.splashdog,
                height: 160,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Gallery3D(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  controller: _controller,
                  onClickItem: (value) {
                    log('Gallery item clicked with index: $value');
                    setState(() {
                      selectedMembershipId =
                          controller.memberships[value]['id'];
                    });
                    log('selectedMembershipId: $selectedMembershipId');
                  },
                  itemConfig: GalleryItemConfig(
                    radius: 10,
                    height: MediaQuery.of(context).size.height,
                    shadows: [
                      const BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 0,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  itemBuilder: (context, index) {
                    final membership = controller.memberships[index];

                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff2ACDC3),
                            Color(0xff15B1A8),
                            Color(0xff00968D)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "\$${membership['price']}",
                            style: textTheme(context).headlineLarge?.copyWith(
                                color: colorScheme(context).onPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Per Month",
                            style: textTheme(context).titleSmall?.copyWith(
                                color: colorScheme(context).onPrimary),
                          ),
                          Divider(
                            color: colorScheme(context).onPrimary,
                            thickness: 2,
                            height: 40,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 8,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: colorScheme(context).onPrimary,
                                      size: 16,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          membership['policies'] ??
                                              "No policies available",
                                          style: textTheme(context)
                                              .labelSmall
                                              ?.copyWith(
                                                  color: colorScheme(context)
                                                      .onPrimary),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: CustomButton(
                              onTap: () {
                                setState(() {
                                  selectedMembershipId = membership['id'];
                                });

                                log('Selected membership ID (via button) set to: $selectedMembershipId');
                              },
                              text: membership['name'],
                              borderRadius: 16,
                              padding: const EdgeInsets.all(0),
                              fontWeight: FontWeight.w500,
                              textSize: 14,
                              color: colorScheme(context).onPrimary,
                              textColor: colorScheme(context).outline,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Consumer<SettingsController>(
                  builder: (context, value, child) => CustomButton(
                    onTap: () {
                      if (selectedMembershipId != null) {
                        value.purchaseMemberShip(userId: selectedMembershipId!);
                        context.pushNamed(AppRoute.bussinessProfile);

                        log('Purchasing membership with ID: $selectedMembershipId');
                      } else {
                        log('No membership selected');
                        showSnackbar(
                            message: "Please select a membership to purchase.");
                      }
                    },
                    text: "confirm".tr(),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
