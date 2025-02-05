class ApiEndpoints {
  static const String baseUrl = 'https://pet-insta.nextwys.com/api';

  static const String baseImageUrl =
      'https://pet-insta.nextwys.com/public/uploads/';

  /// ############################# [Auth] #############################
  static const String sendOtp = '$baseUrl/send-otp';
  static const String verifyOtp = '$baseUrl/verify-otp';
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String forgotPassword = '$baseUrl/password/forgot';
  static const String passwordReset = '$baseUrl/password/reset';

  /// ############################# [Profile] #############################
  static const String baseUser = '$baseUrl/user/';
  static const String setUserName = '$baseUrl/user/username';
  static const String setUserProfileImage = '$baseUrl/user/profile/image';
  static const String setUserAbout = '$baseUrl/user/about';
  static const String updateUserAbout = '$baseUrl/profile/update';
  static const String getUserProfile = '$baseUrl/user/profile';
  static const String getAllUsers = '$baseUrl/users/feed?search=';

  /// ############################# [Profile Settings] #############################

  /// ############################# [Profile Settings] #############################
  /// ############################# [Home] #############################
  /// ############################# [Posts] #############################
  static const String getPostFeed = '$baseUrl/feed';
  static const String getMyPosts = '$baseUrl/user/posts';
  static const String getAPost = '$baseUrl/posts/';
  static const String submitAPost = '$baseUrl/posts';
  static const String postComments = '$baseUrl/comments/';

  /// ############################# [Stories] #############################
  static const String getOwnStories = '$baseUrl/stories/own';
  static const String getFollowersStories = '$baseUrl/stories/followers';
  static const String postStory = '$baseUrl/stories';

  /// ############################# [Sub-Part-of-Endpoint] #############################
  static const String toggleLike = '/toggle-like';
  static const String toggleSave = '/toggle-save';
  static const String togglePin = '/toggle-pin';
  static const String toggleFavorite = '/toggle-favorite';
  static const String comment = '/comment';
  static const String reply = '/reply';
  static const String getFollowers = '/followers';
  static const String getFollowing = '/following';
  static const String addMember = '/members';
  static const String leaveGroup = '/leave';
  static const String setGroupIcon = '/set-icon';
  static const String getMessages = '/messages';
  static const String markMessagesAsRead = '/mark-messages-as-read';
  static const String joinGroup = '/join';

  /// ############################# [Chat] #############################
  /// ############################# [Individual] #############################
  static const String individualChatRoom = '$baseUrl/chat-rooms';
  static const String directMessage = '$baseUrl/chat/direct/';

  /// ############################# [Groups] #############################
  static const String fetchMyGroups = '$baseUrl/user/groups';
  static const String fetchAllGroups = '$baseUrl/chat-groups';
  static const String groups = '$baseUrl/groups';
  static const String updateGroups = '$baseUrl/chat-groups/update/';
  static const String group = '$baseUrl/group/';

  /// ############################# [ Recipe ] #############################

  static const String uploadRecipe = '$baseUrl/recipes/post';
  static const String getRecipe = '$baseUrl/recipes/feed';
  static const String userRecipe = '$baseUrl/user/recipes';
  static const String recipe = '$baseUrl/recipes/';
  static const String recipeCommentForLike = '$baseUrl/recipe-comments/';
  static const String likeRecipeComment = '/like';
  static const String replyRecipeComment = '$baseUrl/recipe-comments/1/reply';

  /// ############################# [ Shop ] #############################
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/categories';

  /// ############################# [Report] //############################
  static const String reportRecipe = '$baseUrl/report-recipe';
}
