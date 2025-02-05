import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_images.dart';
import '/src/features/notification/page/notification_page.dart';
import '../home/model/home_model.dart';
import '../home/widget/old_post_widget.dart';

class ExplorePage extends StatefulWidget {
  final String? imageUrl;
  final Map<String, dynamic> queryParameters;

  const ExplorePage({
    super.key,
    this.imageUrl,
    this.queryParameters = const {},
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<PostsModel> posts = [
    PostsModel(
      postMedia: [
        'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        'https://videos.pexels.com/video-files/2796078/2796078-uhd_2560_1440_25fps.mp4',
      ]..shuffle(),
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
  void initState() {
    super.initState();
    if (widget.imageUrl != null) {
      _shufflePostsAndSetFirstImage(widget.imageUrl!);
    }
  }

  void _shufflePostsAndSetFirstImage(String selectedImage) {
    setState(() {
      for (var post in posts) {
        post.postMedia.shuffle(); // Shuffle the media
        if (post.postMedia.contains(selectedImage)) {
          post.postMedia.remove(selectedImage); // Remove and add it first
          post.postMedia.insert(0, selectedImage);
        }
      }
    });
  }

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
        title: Text("explore".tr()),
        actions: [
          GestureDetector(
            onTap: () {
              // context.pushNamed(AppRoute.notificationPage);
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const NotificationPage(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.fade);
            },
            child: SvgPicture.asset(AppIcons.notiIcon),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return OldPostWidget(
            post: posts[index],
            showDescription: true,
          );
        },
      ),
    );
  }
}
