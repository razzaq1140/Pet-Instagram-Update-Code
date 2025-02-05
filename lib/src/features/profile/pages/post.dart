import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_images.dart';
import '/src/features/home/widget/old_post_widget.dart';
import '/src/router/routes.dart';
import '../../home/model/home_model.dart';

class PostsPage extends StatefulWidget {
  final String? imageUrl;
  final Map<String, dynamic> queryParameters;
  const PostsPage({
    super.key,
    this.imageUrl,
    required this.queryParameters,
  });

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final List<PostsModel> posts = [
    PostsModel(
      postMedia: [
        'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        'https://videos.pexels.com/video-files/2796078/2796078-uhd_2560_1440_25fps.mp4',
      ],
      userName: 'Furry Pals',
      userImage:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      postTime: '12 ${'minutes_ago'.tr()}',
      likes: "6M",
      comments: 3000,
      description:
          'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text("posts".tr()),
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoute.chatPage);
            },
            child: SvgPicture.asset(AppIcons.chatIcon),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoute.notificationPage);
            },
            child: SvgPicture.asset(AppIcons.notiIcon),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return OldPostWidget(
            post: posts[index],
          );
        },
      ),
    );
  }
}
