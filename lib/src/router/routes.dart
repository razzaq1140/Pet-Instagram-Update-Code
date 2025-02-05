import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/features/auth/pages/sign_in_page/pages/reset_password_page.dart';
import '../features/auth/pages/sign_in_page/pages/forget_password_page.dart';
import '/src/features/auth/pages/sign_in_page/pages/sign_in_page.dart';
import '../features/auth/pages/sign_in_page/pages/verify_otp_page.dart';
import '/src/features/auth/pages/sign_up_page/pages/confirm_email_page.dart';
import '/src/features/auth/pages/sign_up_page/pages/upload_image_page.dart';
import '/src/features/auth/pages/sign_up_page/pages/user_name_page.dart';
import '/src/features/buyer_and_seller/seller/pages/seller_center_page.dart';
import '/src/features/categories/pages/top_sellers.dart';
import '/src/features/feed_and_recipe/pages/feed_and_recipe_page.dart';
import '/src/features/chat/group_chat/pages/group_message_page.dart';
import '../features/chat/send_selected_image_page.dart';
import '/src/features/home/pages/add_story_page.dart';
import '/src/features/home/pages/story_view_page.dart';
import '/src/features/chat/individual_chat/pages/chat_request_page.dart';
import '/src/features/chat/individual_chat/pages/message_page.dart';
import '/src/features/payment_page/payment_detail.dart';
import '/src/features/profile/pages/friend_profile_page.dart';
import '/src/features/profile/pages/my_profile_page.dart';
import '/src/features/profile/pages/post.dart';
import '/src/features/profile/pages/profile_message_page.dart';
import '/src/features/quill_editor_page.dart';
import '/src/features/search/explore_page.dart';
import '/src/features/search/search_page.dart';
import '/src/features/seller_dashbord/pages/customers/all_customers_page.dart';
import '/src/features/seller_dashbord/pages/customers/customers_detail_page.dart';
import '/src/features/settings/pages/about_page.dart';
import '/src/features/settings/pages/faqs_page.dart';
import '/src/features/settings/pages/favourite_page.dart';
import '/src/features/settings/pages/language_page.dart';
import '/src/features/settings/pages/order_tracking_page.dart';
import '/src/features/settings/pages/privcy_policy_page.dart';
import '/src/features/settings/pages/setting_page.dart';
import '/src/features/settings/pages/terms_and_conditions_page.dart';
import '/src/router/route_transition.dart';
import '../features/add_address/pages/address_page.dart';
import '../features/auth/pages/sign_up_page/pages/create_new_password.dart';
import '../features/auth/pages/sign_up_page/pages/pet_form_page.dart';
import '../features/auth/pages/sign_up_page/pages/sign_up_page.dart';
import '../features/buyer_and_seller/seller/pages/add_product_page.dart';
import '../features/cart/pages/cart_page.dart';
import '../features/categories/pages/pet_categories_page.dart';
import '../features/chat/chat_page.dart';
import '../features/chat/individual_chat/models/chat_room_model.dart';
import '../features/custom_navigation_bar.dart';
import '../features/feed_and_recipe/pages/upload_recipe_page.dart';
import '../features/follower/pages/follower_screen.dart';
import '../features/chat/group_chat/model/joined_chat_group_model.dart';
import '../features/chat/group_chat/widget/group_bottom_sheet.dart';
import '../features/home/model/story_model.dart';
import '../features/home/pages/add_post_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/notification/page/notification_page.dart';
import '../features/order_confirmation/page/order_confirmation_page.dart';
import '../features/order_history/pages/order_history_page.dart';
import '../features/product_details/product_detail_page.dart';
import '../features/ratings/page/rating_page.dart';
import '../features/seller_dashbord/pages/product/all_products_page.dart';
import '../features/seller_dashbord/pages/product/product_statement_page.dart';
import '../features/seller_dashbord/pages/sales/all_sales_page.dart';
import '../features/seller_dashbord/pages/sales/sales_statement_page.dart';
import '../features/settings/my_order_page.dart';
import '../features/settings/pages/account_page.dart';
import '../features/settings/pages/bussiness_profile_page.dart';
import '../features/settings/pages/membership_page.dart';
import '../features/story/page/story_page.dart';
import '../features/welcome/pages/splash_screen.dart';
import '../features/welcome/pages/welcome_screen.dart';
import '../models/product_model.dart';

class MyAppRouter {
  static final router = GoRouter(
    initialLocation: '/${AppRoute.splashScreen}',
    routes: [
      GoRoute(
        name: AppRoute.splashScreen,
        path: '/${AppRoute.splashScreen}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        name: AppRoute.welcomeScreen,
        path: '/${AppRoute.welcomeScreen}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const WelcomePage(),
        ),
      ),
      //Auth Screen
      GoRoute(
        name: AppRoute.signIn,
        path: '/${AppRoute.signIn}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const SignInScreen(),
        ),
      ),
      GoRoute(
        name: AppRoute.signUpPage,
        path: '/${AppRoute.signUpPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const SignUpPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.confirmationScreen,
        path: '/${AppRoute.confirmationScreen}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: ConfirmEmailPage(extra: state.extra as Map<String, String?>),
        ),
      ),
      GoRoute(
        name: AppRoute.createNewPassword,
        path: '/${AppRoute.createNewPassword}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child:
              CreateNewPasswordPage(extra: state.extra as Map<String, Object?>),
        ),
      ),
      GoRoute(
        name: AppRoute.petFormPage,
        path: '/${AppRoute.petFormPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: PetFormPage(
            image: state.extra as File?,
          ),
        ),
      ),
      GoRoute(
        name: AppRoute.userNamePage,
        path: '/${AppRoute.userNamePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const UserNamePage(),
        ),
      ),
      GoRoute(
        name: AppRoute.navigationBar,
        path: '/${AppRoute.navigationBar}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const CustomBottomNavigationBar(),
        ),
      ),
      GoRoute(
        name: AppRoute.chatPage,
        path: '/${AppRoute.chatPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const ChatPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.followerScreen,
        path: '/${AppRoute.followerScreen}',
        pageBuilder: (context, state) {
          final userId = state.extra as int;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: PetFollowerScreen(
              queryParameters: state.uri.queryParameters,
              userId: userId,
            ),
          );
        },
      ),

      GoRoute(
        name: AppRoute.petImagePage,
        path: '/${AppRoute.petImagePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
            context: context, state: state, child: const UploadImagePage()),
      ),
      GoRoute(
        name: AppRoute.feedPage,
        path: '/${AppRoute.feedPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const FeedPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.homePage,
        path: '/${AppRoute.homePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
            context: context, state: state, child: const HomePage()),
      ),
      GoRoute(
        name: AppRoute.storyPage,
        path: '/${AppRoute.storyPage}',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: StoryViewPage(
              index: data['index'] as int,
              stories: data['stories'] as List<AllUserStoryModel>,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoute.addStoryPage,
        path: '/${AppRoute.addStoryPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
            context: context, state: state, child: const AddStoryPage()),
      ),
      GoRoute(
        name: AppRoute.addPostPage,
        path: '/${AppRoute.addPostPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
            context: context, state: state, child: AddPostPage()),
      ),

      GoRoute(
        name: AppRoute.bussinessProfile,
        path: '/${AppRoute.bussinessProfile}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const BussinessProfilePage(),
        ),
      ),
      GoRoute(
        name: AppRoute.statusStory,
        path: '/${AppRoute.statusStory}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const StatusStoryPage(),
        ),
      ),

      GoRoute(
        name: AppRoute.categoriesPage,
        path: '/${AppRoute.categoriesPage}',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, Object?>? ?? {};

          final String categoryName = (data['categoryName'] as String?) ?? '';

          final int categoryId = (data['categoryId'] as int?) ?? 0;

          final TextEditingController searchController =
              (data['searchController'] as TextEditingController?) ??
                  TextEditingController();

          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: PetCategoriesPage(
              categoryName: categoryName,
              categoryId: categoryId,
              searchController: searchController,
            ),
          );
        },
      ),

      GoRoute(
        name: AppRoute.myProfile,
        path: '/${AppRoute.myProfile}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const MyProfilePage(),
        ),
      ),
      GoRoute(
          name: AppRoute.friendProfilePage,
          path: '/${AppRoute.friendProfilePage}',
          pageBuilder: (context, state) {
            final id = state.extra as int;

            return buildPageWithFadeTransition<void>(
              context: context,
              state: state,
              child: FriendProfilePage(
                userId: id,
              ),
            );
          }),
      GoRoute(
        name: AppRoute.profileMessage,
        path: '/${AppRoute.profileMessage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const ProfileMessagePage(),
        ),
      ),
      //PyamentPages
      GoRoute(
          name: AppRoute.orderconfirmation,
          path: '/${AppRoute.orderconfirmation}',
          pageBuilder: (context, state) {
            final orderRsponse = state.extra as bool;

            return buildPageWithFadeTransition<void>(
              context: context,
              state: state,
              child: OrderConfirmationPage(
                isBuyNow: orderRsponse,
              ),
            );
          }),
      GoRoute(
          name: AppRoute.paymentDetail,
          path: '/${AppRoute.paymentDetail}',
          pageBuilder: (context, state) {
            return buildPageWithFadeTransition<void>(
              context: context,
              state: state,
              child: const PaymentDetailPage(),
            );
          }),
      GoRoute(
        name: AppRoute.cartPage,
        path: '/${AppRoute.cartPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const CartPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.addProduct,
        path: '/${AppRoute.addProduct}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AddProductPage(),
        ),
      ),

      GoRoute(
        name: AppRoute.productDetailPage,
        path: '/${AppRoute.productDetailPage}',
        pageBuilder: (context, state) {
          final product = state.extra as ProductModel;
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: ProductDetailPage(product: product),
          );
        },
      ),

      GoRoute(
        name: AppRoute.ratingPage,
        path: '/${AppRoute.ratingPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const RatingPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.uploadRecipe,
        path: '/${AppRoute.uploadRecipe}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const UploadRecipePage(),
        ),
      ),

      GoRoute(
        name: AppRoute.messagePage,
        path: '/${AppRoute.messagePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: MessagePage(
                chatRoomOtherUserModel: state.extra as ChatRoomOtherUserModel)),
      ),

      //PrivcyScreens
      GoRoute(
        name: AppRoute.privcyPolicy,
        path: '/${AppRoute.privcyPolicy}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const PrivacyPolicyPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.termsAndCondition,
        path: '/${AppRoute.termsAndCondition}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const TermsAndConditionsPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.faqsPage,
        path: '/${AppRoute.faqsPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const FaqsPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.notificationPage,
        path: '/${AppRoute.notificationPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const NotificationPage(),
        ),
      ),
      //createGroup
      GoRoute(
        name: AppRoute.createGroup,
        path: '/${AppRoute.createGroup}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const CreateGroupBottomSheet(),
        ),
      ),
      GoRoute(
        name: AppRoute.sendSelectedImage,
        path: '/${AppRoute.sendSelectedImage}',
        pageBuilder: (context, state) {
          Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return buildPageWithFadeTransition<void>(
              context: context,
              state: state,
              child: SendSelectedImagePage(
                image: data['image'] as File,
                isIndividual: data['isIndividual'] as bool,
                individualChatUserID: data['individualChatUserID'] as int?,
              ));
        },
      ),
      GoRoute(
        name: AppRoute.setting,
        path: '/${AppRoute.setting}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const SettingPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.accountPage,
        path: '/${AppRoute.accountPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AccountPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.membershipPage,
        path: '/${AppRoute.membershipPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const MembershipPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.addressPage,
        path: '/${AppRoute.addressPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AddNewAddresPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.aboutPage,
        path: '/${AppRoute.aboutPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const AboutPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.orderTrackingPage,
        path: '/${AppRoute.orderTrackingPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const OrderTrackingPage(),
        ),
      ),

      GoRoute(
        name: AppRoute.explorePage,
        path: '/${AppRoute.explorePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: ExplorePage(
            imageUrl: state
                .uri.queryParameters['imageUrl'], // Retrieve query parameter
          ),
        ),
      ),

      //TopSeller
      GoRoute(
        name: AppRoute.topSeller,
        path: '/${AppRoute.topSeller}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: TopSellersPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.favoritePage,
        path: '/${AppRoute.favoritePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const FavouritePage(),
        ),
      ),

      GoRoute(
        name: AppRoute.groupChat,
        path: '/${AppRoute.groupChat}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: GroupMessagePage(
            group: state.extra as JoinedChatGroupModel,
          ),
        ),
      ),
      GoRoute(
        name: AppRoute.languagePage,
        path: '/${AppRoute.languagePage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const LanguagePage(),
        ),
      ),
      GoRoute(
        name: AppRoute.searchScreen,
        path: '/${AppRoute.searchScreen}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const SearchPage(),
        ),
      ),

      GoRoute(
        name: AppRoute.postPage,
        path: '/${AppRoute.postPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: PostsPage(
            imageUrl: state.uri.queryParameters['imageUrl'],
            queryParameters: const {},
          ),
        ),
      ),

      //  HistoryPages
      GoRoute(
        name: AppRoute.salesStatement,
        path: '/${AppRoute.salesStatement}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const SalesStatementPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.allSales,
        path: '/${AppRoute.allSales}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const AllSalesPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.productStatement,
        path: '/${AppRoute.productStatement}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const ProductStatementPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.allProducts,
        path: '/${AppRoute.allProducts}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const AllProductsPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.customerDetail,
        path: '/${AppRoute.customerDetail}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const CustomersDetailPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.allCustomers,
        path: '/${AppRoute.allCustomers}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const AllCustomersPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.myOrder,
        path: '/${AppRoute.myOrder}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const MyOrderPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.orderHistory,
        path: '/${AppRoute.orderHistory}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const OrderHistoryPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.sellerCenter,
        path: '/${AppRoute.sellerCenter}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const SellerCenterPage(),
          );
        },
      ),

      GoRoute(
        name: AppRoute.quillEditor,
        path: '/${AppRoute.quillEditor}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const QuillEditorPage(
              initialData:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoute.chatRequest,
        path: '/${AppRoute.chatRequest}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const ChatRequestPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.forgetPasswordPage,
        path: '/${AppRoute.forgetPasswordPage}',
        pageBuilder: (context, state) {
          return buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: const ForgetPasswordPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.resetPasswordPage,
        path: '/${AppRoute.resetPasswordPage}',
        pageBuilder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return buildPageWithFadeTransition<void>(
              context: context,
              state: state,
              child: ResetPasswordPage(
                email: data['email'] as String,
                otp: data['otp'] as int,
              ));
        },
      ),
      GoRoute(
        name: AppRoute.verifyOtpPage,
        path: '/${AppRoute.verifyOtpPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
            context: context,
            state: state,
            child: VerifyOtpPage(email: state.extra as String)),
      ),
    ],
  );

  static void clearAndNavigate(BuildContext context, String name) {
    while (context.canPop()) {
      context.pop();
    }
    context.pushReplacementNamed(name);
  }

  static void popUntil(BuildContext context, {required int until}) {
    for (var i = 0; i < until; i++) {
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  static void popUntilAndNavigate(BuildContext context,
      {required String name, required int until, dynamic extra}) {
    for (var i = 0; i < until; i++) {
      if (context.canPop()) {
        context.pop();
      }
      context.pushNamed(name, extra: extra);
    }
  }
}

class AppRoute {
  static const String errorPage = 'error-page';
  static const String splashScreen = 'splash-page';
  static const String welcomeScreen = 'welcomeScreen-page';
  //authScreen
  static const String signIn = 'SignInScreen-page';
  static const String signUpPage = 'signUp-page';
  static const String confirmationScreen = 'confirmationScreen-page';
  static const String createNewPassword = "createNewPassword_page";
  static const String petFormPage = 'petFormPage-page';
  static const String userNamePage = 'userNamePage-page';
  static const String petImagePage = 'PetImage-page';
  static const String forgetPasswordPage = 'forget-password-page';
  static const String resetPasswordPage = "reset-password_page";
  static const String verifyOtpPage = 'verify-otp-page';
  static const String homePage = 'homePage-page';
  static const String addPostPage = 'add-post-page';
  static const String storyPage = 'story-page';
  static const String addStoryPage = 'add-story-page';

  //NavigationBarScreens
  static const String navigationBar = 'navigationBar-page';
  static const String searchScreen = 'searchScreen-page';
  static const String feedPage = 'Feed-page';
  static const String chatPage = 'petChat-page';
  static const String followerScreen = 'follower-page';
  static const String myProfile = 'editProfile-page';
  static const String friendProfilePage = 'friend-profile-page';
  static const String profileMessage = 'profileMessage-page';
  static const String statusStory = 'statusStory-page';
  static const String sellerCenter = 'SellerCenter-page';

  //Categories_Screens
  //topSeller
  static const String topSeller = 'topSeller-page';
  static const String categoriesPage = 'categories-page';
  static const String petShopping = 'shopping-page';
  static const String petToys = 'toys-page';
  static const String petTravel = 'travel-page';
  static const String petAccessories = 'petAccessories-page';
  static const String petFood = 'petFood-page';
  static const String petHouse = 'petHouse-page';

  //PaymentScreen
  static const String orderconfirmation = 'orderconfirmation-page';
  static const String cartPage = 'cart-page';
  static const String paymentDetail = 'payemntDetail-page';
  static const String addressPage = 'checkOut-page';
  //addProducts
  static const String addProduct = 'addProduct-page';
  static const String productDetailPage = 'productDetail-page';
  static const String ratingPage = 'rating-page';
  //  static const String uploadIngredient = "uploadIngredient-page";
  static const String uploadRecipe = "uploadRecipe-page";
  //MessageScreen
  static const String messagePage = "message-page";
  static const String createGroup = "createGroup-page";
  static const String sendSelectedImage = "send-selected-image-page";

  //NotificationPages  bussinessProfile
  static const String notificationPage = "notification-page";
  static const String bussinessProfile = "bussinessProfile-page";

  //setting
  static const String setting = "setting-page";
  static const String accountPage = "accountScreen-page";
  static const String membershipPage = "membership-page";
  static const String faqsPage = "faqs-page";
  static const String privcyPolicy = "privcy-page";
  static const String termsAndCondition = "termsAndCondition-page";
  static const String aboutPage = "about-page";
  static const String orderTrackingPage = "order-tracking-page";
  static const String favoritePage = "favorite-page";
  static const String languagePage = "language-page";
  static const String myOrder = "my_FOrder-page";

  //search screens
  static const String explorePage = "explore-page";

  //group chat
  static const String groupChat = 'group-chat';
  //profile
  static const String postPage = 'post-page';
  static const String friendsProfilePage = 'firendsProfile';
  //Seller
  static const String describePage = 'describe-page';
  //SellerDashBord Pages

  static const String salesStatement = 'salesStatement-page';
  static const String allSales = 'allSales-page';
  static const String productStatement = 'productStatement-page';
  static const String allProducts = 'allProducts-page';
  static const String customerDetail = 'customerDetail-page';
  static const String allCustomers = 'allCustomers-page';
  //OrderHistoryPages
  static const String orderHistory = 'OrderHistory-page';
  static const String quillEditor = 'quillEditor-page';
  static const String chatRequest = 'chatRequest-page';
}
