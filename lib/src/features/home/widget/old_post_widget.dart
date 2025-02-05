import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '/src/features/home/widget/show_full_screen_image.dart'; // Ensure you have this import for the FullScreenImageViewer
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/constants/app_images.dart';
import '../../../router/routes.dart';
import '../model/home_model.dart';

class OldPostWidget extends StatefulWidget {
  final PostsModel post;
  final bool showDescription;
  final Widget? child;
  final String? customPostTime;

  const OldPostWidget({
    super.key,
    required this.post,
    this.customPostTime,
    this.showDescription = true,
    this.child,
  });

  @override
  State<OldPostWidget> createState() => _OldPostWidgetState();
}

class _OldPostWidgetState extends State<OldPostWidget> {
  bool isFavorite = false;
  bool isBookmarked = false;
  VideoPlayerController? _videoController;
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize video controller if the first media is a video
    if (widget.post.postMedia.isNotEmpty &&
        _isVideo(widget.post.postMedia[0])) {
      _initializeVideo(widget.post.postMedia[0]);
    }

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page?.round() ?? 0;

        // If the new media is a video, initialize the controller
        if (_isVideo(widget.post.postMedia[currentIndex])) {
          _initializeVideo(widget.post.postMedia[currentIndex]);
        } else {
          // Dispose video controller if current media is not a video
          _videoController?.dispose();
          _videoController = null;
        }
      });
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _isVideo(String url) {
    return url.endsWith('.mp4') || url.endsWith('.avi') || url.endsWith('.mov');
  }

  void _initializeVideo(String videoUrl) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Rebuild to show video when initialized
        _videoController
            ?.play(); // Automatically play the video once initialized
      }).catchError((error) {
        log('Error initializing video: $error');
      });
  }

  final List<Map<String, dynamic>> comments = [
    {
      "user": "_jigss_",
      "comment": "🙌",
      "timeAgo": "2d",
      "likes": 1,
      "isLiked": true,
    },
    {
      "user": "zain_dev_",
      "comment": "❤️",
      "timeAgo": "20h",
      "likes": 1,
      "isLiked": false,
      "isAuthor": true,
    },
    {
      "user": "basit_._",
      "comment": "Helpful!",
      "timeAgo": "2d",
      "likes": 1,
      "isLiked": false,
    },
    {
      "user": "zain_dev_",
      "comment": "@basit_._ thanks",
      "timeAgo": "20h",
      "likes": 0,
      "isLiked": false,
      "isAuthor": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme(context).onSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoute.myProfile);
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(AppImages.pinkDog),
                ),
              ),
              title: Text(
                widget.post.userName,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: colorScheme(context).outline),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Report') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reported this post')),
                    );
                  } else if (value == 'Block') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Blocked this user')),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Report', 'Block'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          // Media section with PageView and indicator
          if (widget.post.postMedia.any((media) => _isVideo(media)))
            _buildVideoPageView()
          else
            _buildStaggeredImages(),
          _buildActionBar(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 26,
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.post.userImage,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoute.myProfile);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.post.userImage,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoute.myProfile);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.post.userImage,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: RichText(
                      text: TextSpan(
                          text: 'liked_by'.tr(),
                          style: textTheme(context).bodySmall,
                          children: [
                        TextSpan(
                          text: 'Furry',
                          style: textTheme(context).bodyMedium,
                        ),
                        TextSpan(text: 'and_others'.tr())
                      ])),
                ),
                if (widget.showDescription)
                  Text(
                    widget.post.description, // Show description
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    softWrap: true,
                  )
                else if (widget.child != null) ...[
                  widget.child!,
                ],
                Text(
                  widget.customPostTime ?? widget.post.postTime,
                  style: const TextStyle(
                    color: AppColor.hintText,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPageView() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.post.postMedia.length,
            itemBuilder: (context, index) {
              final mediaUrl = widget.post.postMedia[index];
              return _isVideo(mediaUrl)
                  ? _buildVideoContent()
                  : _buildImageContent(mediaUrl);
            },
          ),
        ),
        Positioned(
          bottom: 10,
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.post.postMedia.length,
            effect: ScrollingDotsEffect(
              activeDotColor: Theme.of(context).colorScheme.onPrimary,
              dotColor: AppColor.hintText,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaggeredImages() {
    final imageUrls =
        widget.post.postMedia.where((url) => !_isVideo(url)).toList();

    // Handle cases for 1 to 4 images
    if (imageUrls.length == 1) {
      // If there is only one image, show it full screen
      return GestureDetector(
        onTap: () => _showFullScreenImage(imageUrls[0]),
        child: Padding(
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 350,
            child: CachedNetworkImage(
              imageUrl: imageUrls[0],
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColor.hintText,
                highlightColor: AppColor.hintText,
                child: Container(color: AppColor.hintText),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      );
    } else if (imageUrls.length == 2) {
      // If there are 2 images, show them side by side
      return GestureDetector(
        child: Row(
          children: imageUrls.map((imageUrl) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 350,
                  child: GestureDetector(
                    onTap: () => _showFullScreenImage(imageUrl),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColor.hintText,
                        highlightColor: AppColor.hintText,
                        child: Container(color: AppColor.hintText),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (imageUrls.length == 3) {
      // If there are 3 images, staggered layout
      return Padding(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 300,
          child: StaggeredGrid.count(
            crossAxisCount: 3, // Number of columns in the grid
            children: List.generate(imageUrls.length, (index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(imageUrls[index]),
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  height: 300,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColor.hintText,
                    highlightColor: AppColor.hintText,
                    child: Container(color: AppColor.hintText),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            }),
          ),
        ),
      );
    } else if (imageUrls.length == 4) {
      // If there are 4 images, show them in a 2x2 grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2x2 grid
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(imageUrls[index]),
            child: CachedNetworkImage(
              imageUrl: imageUrls[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColor.hintText,
                highlightColor: AppColor.hintText,
                child: Container(color: AppColor.hintText),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        },
      );
    } else if (imageUrls.length == 5) {
      // For 5 images, show them in a scrollable PageView with an indicator
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColor.hintText,
                    highlightColor: AppColor.hintText,
                    child: Container(color: AppColor.hintText),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: imageUrls.length, // Show indicator for all 5 images
              effect: ScrollingDotsEffect(
                activeDotColor: Theme.of(context).colorScheme.onPrimary,
                dotColor: AppColor.hintText,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
          ),
        ],
      );
    }

    return Container(); // Fallback in case there are no images
  }

  Widget _buildImageContent(String imageUrl) {
    return SizedBox(
      height: 350,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColor.hintText,
          highlightColor: AppColor.hintText,
          child: Container(color: AppColor.hintText),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    // Check if the URL is a valid file path or a network image
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      // It's a network image
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FullScreenImageViewer(imageUrl: imageUrl),
        ),
      );
    } else {
      // It's a local file
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FullScreenImageViewer(imageFile: File(imageUrl)),
        ),
      );
    }
  }

  Widget _buildVideoContent() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _videoController!.value.isPlaying
                ? _videoController!.pause()
                : _videoController!.play();
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 39 / 32,
              child: VideoPlayer(_videoController!),
            ),
            if (!_videoController!.value.isPlaying)
              Icon(
                Icons.play_arrow,
                size: 60,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 5),
              Text(widget.post.likes),
              const SizedBox(width: 17),
              GestureDetector(
                onTap: () {
                  showCommentsModal(context);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.commentIcon),
                    const SizedBox(width: 5),
                    Text('${widget.post.comments}'),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Share.share(widget.post.description);
                },
                child: SvgPicture.asset(AppIcons.sendIcon),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void showCommentsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromViewPadding(
            View.of(context).viewInsets,
            View.of(context).devicePixelRatio,
          ),
          child: CustomComment(
            comments: comments,
            onSendComment: (newComment) {
              setState(() {
                comments.add({
                  "user": "current_user",
                  "comment": newComment,
                  "timeAgo": "Just now",
                  "likes": 0,
                  "isLiked": false,
                });
              });
            },
            onLikeTapped: (int index) {
              setState(() {
                comments[index]['isLiked'] = !comments[index]['isLiked'];
                if (comments[index]['isLiked']) {
                  comments[index]['likes'] += 1;
                } else {
                  comments[index]['likes'] -= 1;
                }
              });
            },
          ),
        );
      },
    );
  }
}

class CustomComment extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(int index) onLikeTapped;
  final Function(String comment) onSendComment;

  const CustomComment({
    super.key,
    required this.comments,
    required this.onLikeTapped,
    required this.onSendComment,
  });

  @override
  CustomCommentState createState() => CustomCommentState();
}

class CustomCommentState extends State<CustomComment> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColor.hintText,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Comments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller:
                      scrollController, // Use the provided scrollController
                  itemCount: widget.comments.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = widget.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(AppImages.pinkCat),
                      ),
                      title: Row(
                        children: [
                          Text(comment['user'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          if (comment['isAuthor'] == true)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Author',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.hintText,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['comment']),
                          Row(
                            children: [
                              Text(comment['timeAgo'],
                                  style: const TextStyle(
                                      color: AppColor.hintText, fontSize: 12)),
                              const SizedBox(width: 8),
                              const Text(
                                'Reply',
                                style: TextStyle(
                                    color: AppColor.hintText, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.onLikeTapped(index);
                              });
                            },
                            child: Icon(
                              comment['isLiked']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: comment['isLiked']
                                  ? AppColor.appRed
                                  : AppColor.hintText,
                            ),
                          ),
                          Text("${comment['likes']}"),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(AppImages.whiteDog),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _commentController,
                      hint: 'Add a comment...',
                      borderColor:
                          colorScheme(context).outline.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (_commentController.text.isNotEmpty) {
                        setState(() {
                          widget.onSendComment(_commentController.text);
                        });
                        _commentController.clear(); // Clear the input field
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
