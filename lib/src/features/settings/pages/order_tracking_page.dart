import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController trackingID = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          centerTitle: false,
          title: Text(
            "tracking".tr(),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "tracking_id".tr(),
                  style: textTheme(context).titleSmall,
                ),
              ),
              CustomTextFormField(
                controller: trackingID,
                hint: '416841MS4358',
                validator: (value) =>
                    Validation.fieldValidation(value, "tracking_id".tr()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: CustomButton(
                    onTap: () {
                      formKey.currentState!.validate();
                    },
                    text: "track".tr()),
              ),
              Container(
                decoration: BoxDecoration(
                    color: colorScheme(context).onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        color: colorScheme(context).outline.withOpacity(0.4))),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Image.asset(
                        AppIcons.shoppingBagIcon,
                        height: 30,
                      ),
                      title: Text(
                        "order_ready_to_pickup".tr(),
                        style: textTheme(context).bodyMedium,
                      ),
                      subtitle: Text(
                          "Order: #84214 . from Brok Simmons Store 9-27-2024 . 3:51AM",
                          textAlign: TextAlign.left,
                          style: textTheme(context).bodySmall?.copyWith(
                                color: AppColor.hintText,
                              )),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Image.asset(
                        AppIcons.fastDeliveryIcon,
                        height: 30,
                      ),
                      title: Text(
                        "order_ready_to_deliver".tr(),
                        style: textTheme(context).bodyMedium,
                      ),
                      subtitle: Text("Order: #84214 . 9-27-2024 . 3:51AM",
                          textAlign: TextAlign.left,
                          style: textTheme(context).bodySmall?.copyWith(
                                color: AppColor.hintText,
                              )),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Image.asset(
                        AppIcons.deliveredIcon,
                        height: 30,
                      ),
                      title: Text(
                        "order_delivered".tr(),
                        style: textTheme(context).bodyMedium,
                      ),
                      subtitle: Text("Order: #84214 . 9-27-2024 . 3:51AM",
                          textAlign: TextAlign.left,
                          style: textTheme(context).bodySmall?.copyWith(
                                color: AppColor.hintText,
                              )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
