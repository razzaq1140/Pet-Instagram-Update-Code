import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/common/constants/app_images.dart';
import '/src/router/routes.dart';

import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_button.dart';

class ProfileMessagePage extends StatelessWidget {
  const ProfileMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Testing with AssetImage to ensure no network delays are causing the freeze
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        AppImages.pinkGirl,
                        //   'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '25',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text('Post'),
                              ],
                            ),
                            SizedBox(width: 40),
                            Column(
                              children: [
                                Text(
                                  '443',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text('Followers'),
                              ],
                            ),
                            SizedBox(width: 40),
                            Column(
                              children: [
                                Text(
                                  '2,029',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text('Following'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          width: 240,
                          onTap: () {
                            context.pushNamed(AppRoute.myProfile);
                          },
                          text: 'Message',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Whiskers Pet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ' Lorem Ipsum has been the industrys standard dummy text ever since the, when an unknown printer took a galley of type andscrambled it to make.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme(context).outline.withOpacity(0.7)),
                ),
                const SizedBox(height: 16),

                // Highlighted Stories (horizontal scrolling list)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStoryAvatar(context, AppImages.pinkCat),
                      _buildStoryAvatar(context, AppImages.whiteDog),
                      _buildStoryAvatar(context, AppImages.pinkDog),
                      _buildStoryAvatar(context, AppImages.whiteDog),
                      _buildStoryAvatar(context, AppImages.pinkDog),
                      _buildStoryAvatar(context, AppImages.whiteDog),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoute.feedPage);
                          },
                          child: const Icon(Icons.grid_on,
                              size: 30, color: Colors.black54)),
                      const Icon(Icons.video_library,
                          size: 30, color: Colors.black54),
                      const Icon(Icons.portrait,
                          size: 30, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // GridView.builder removed for debugging.
                // Temporarily comment out to isolate if it’s causing the freeze
                // Uncomment if you find the rest works fine

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: 9, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return _buildGridItem(context,
                        'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a story avatar
  Widget _buildStoryAvatar(BuildContext context, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(image), // AssetImage for local images
          ),
        ],
      ),
    );
  }

//  Helper method to build a grid item (commented out for debugging)
  Widget _buildGridItem(BuildContext context, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
