import 'package:blog/controllers/vc_create_post.dart';
import 'package:blog/controllers/vc_dashboard.dart';
import 'package:blog/controllers/vc_edit_profile.dart';
import 'package:blog/controllers/vc_emergency.dart';
import 'package:blog/controllers/vc_forgot_password.dart';
import 'package:blog/controllers/vc_login.dart';
import 'package:blog/controllers/vc_my_post_list.dart';
import 'package:blog/controllers/vc_post_details.dart';
import 'package:blog/controllers/vc_register.dart';
import 'package:blog/controllers/vc_similar_post_list.dart';
import 'package:blog/controllers/vc_splash.dart';
import 'package:flutter/material.dart';

class Routes {
  static const SPLASH = "/splash";
  static const LOGIN = "/login";
  static const REGISTER = "/register";
  static const FORGOT_PASSWORD = "/forgot_password";

  static const DASHBOARD = "/dashboard";
  static const EDIT_PROFILE = "/edit_profile";
  static const CREATE_POST = "/create_post";
  static const MY_POSTS = "/my_post_list";
  static const SIMILAR_POSTS = "/similar_post_list";
  static const POST_DETAILS = "/post_details";

  static const EMERGENCY = "/emergency";

  static Widget initial() {
    return const SplashVC();
  }

  static Map<String, WidgetBuilder> list() {
    return {
      LOGIN: (context) => const LoginVC(),
      REGISTER: (context) => const RegisterVC(),
      FORGOT_PASSWORD: (context) => const ForgotPasswordVC(),
      DASHBOARD: (context) => const DashboardVC(),
      EDIT_PROFILE: (context) => const EditProfileVC(),
      CREATE_POST: (context) => const CreatePostVC(),
      MY_POSTS: (context) => const MyPostsVC(),
      EMERGENCY: (context) => const EmergencyVC(),
      SIMILAR_POSTS: (context) => const SimilarPostsVC(),
      POST_DETAILS: (context) => const PostDetailsVC()
    };
  }
}
