import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_button.dart';
import '/src/router/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      AppIcons.outlineDog,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.38,
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: 230,
                    child: SizedBox(
                      height: 350,
                      width: width,
                      child: Image.asset(
                        AppImages.petsImages,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "welcome".tr(),
              style: GoogleFonts.fredoka(
                textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme(context).onSurface),
              ),
            ),
            Text(
              "tagline".tr(),
              style: GoogleFonts.fredoka(
                textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme(context).onSurface),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                CustomButton(
                    onTap: () {
                      context.pushNamed(AppRoute.signUpPage);
                    },
                    text: 'sign_up'.tr()),
                const SizedBox(height: 10),
                CustomButton(
                  onTap: () {
                    context.pushNamed(AppRoute.signIn);
                  },
                  text: 'sign_in'.tr(),
                  textColor: colorScheme(context).onSurface,
                  borderColor: colorScheme(context).outline.withOpacity(0.2),
                  color: colorScheme(context).surface,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
