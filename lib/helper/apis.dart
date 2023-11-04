class APIs {
  static const String BASE_URL = "blogpro.kstechnologies.co";
  static const String PATH_URL = "API/";

  static const String IMAGE_PATH_URL = "http://blogpro.kstechnologies.co/API/";

  static const String LOGIN = "userlogin.php";
  static const String REGISTER = "signup.php";
  static const String FORGOT_PASSWORD = "forgetpwd.php";
  static const String CHANGE_PASSWORD = "";

  static const String GET_PROFILE = "Get_Profile.php";
  static const String UPDATE_PROFILE = "update_profile.php";
  static const String UPLOAD_PROFILE = "update_profile_photo.php";
  static const String TOGGLE_NOTIFICATION = "ENABLE_DISABLE_NOTIFICATION.php";
  static const String GET_NOTIFICATIONS = "getNotifications.php";

  static const String GET_ALL_USERS = "getAllUsers.php";
  static const String GET_MY_FOLLOWERS = "getMyFollowers.php";
  static const String INSERT_FOLLOWER = "Followers_Insert.php";
  static const String DELETE_FOLLOWER = "unfollow.php";

  static const String INSERT_POST = "post_insert.php";
  static const String GET_MY_POSTS = "getMyPosts.php";
  static const String GET_SIMILAR_POSTS = "getSimilarPosts.php";
  static const String GET_ALL_POSTS = "getAllPosts.php";
  static const String DELETE_POST = "delete_post.php";

  static const String GET_COMMENTS = "getComments.php";
  static const String GET_COMMENT_COUNTS = "get_count_comments.php";
  static const String INSERT_COMMENT = "Comments_Insert.php";

  static const String GET_LIKES = "getLikes.php";
  static const String GET_LIKE_COUNTS = "get_count_likes.php";
  static const String INSERT_LIKE = "Likes_Insert.php";

}

typedef RepoCallback = void Function(bool isSuccess, String message);
