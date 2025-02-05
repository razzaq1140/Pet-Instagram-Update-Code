import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../provider/story_status_provider.dart';
import '../../../router/routes.dart';

class StatusStoryPage extends StatelessWidget {
  const StatusStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatusStoryProvider(),
      child: Scaffold(
        body: Consumer<StatusStoryProvider>(
          builder: (context, provider, child) {
            if (provider.stories.isEmpty) {
              return const Center(child: Text('No stories available'));
            }

            // Check if the last story  completed and navigate back to HomePage outside the widget tree
            if (provider.currentIndex == provider.stories.length - 1 &&
                provider.progress >= 1.0) {
              // Use addPostFrameCallback to navigate after the frame is rendered
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushNamed(AppRoute.navigationBar);
              });
            }

            return Stack(
              children: [
                PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: provider.pageController,
                  itemCount: provider.stories.length,
                  itemBuilder: (context, index) {
                    final item = provider.stories[index];

                    if (item.isVideo) {
                      return provider.videoController != null &&
                              provider.videoController!.value.isInitialized
                          ? VideoPlayer(provider.videoController!)
                          : const Center(child: CircularProgressIndicator());
                    }

                    return Image.network(
                      item.url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Return the image when fully loaded
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Text('Failed to load image'));
                      },
                    );
                  },
                  onPageChanged: (index) {
                    provider.currentIndex =
                        index; // Keep track of the current index
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        children:
                            List.generate(provider.stories.length, (index) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: LinearProgressIndicator(
                                value: provider.progressList.isNotEmpty
                                    ? provider.progressList[index]
                                    : 0.0,
                                backgroundColor: Colors.grey,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg'),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9 April',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '2:45 PM',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: GestureDetector(
                    onTap: () {
                      provider.previousStory();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: GestureDetector(
                    onTap: () {
                      provider.nextStory(
                          context); // Pass context here for navigation
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
