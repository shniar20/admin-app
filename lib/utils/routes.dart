import "package:employee/page/component/navigation.dart";
import "package:employee/page/login.dart";
import "package:employee/page/sign_up.dart";
import "package:employee/page/start_page.dart";
import "package:employee/page/view_location.dart";
import "package:employee/page/view_post.dart";
import "package:flutter/material.dart";

final Map<String, WidgetBuilder> appRoutes = {
  '/start_page': (context) => const StartPage(),
  '/sign_up': (context) => const SignUp(),
  '/login': (context) => const Login(),
  '/navigation': (context) => const Navigation(),
  '/view_location': (context) => const ViewLocation(),
  '/view_post': (context) => const ViewPost(),
};
