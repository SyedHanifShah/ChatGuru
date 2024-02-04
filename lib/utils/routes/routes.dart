import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/calls_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/contacts_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/settings_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/screens/bottom_tab_screen.dart';
import 'package:chat_app/screens/varification_screen.dart';
import 'package:chat_app/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> genrateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.splashScreen:
        return _spashRoute();
      case RoutesNames.loginScreen:
        return _loginRoute();
      case RoutesNames.homeScreen:
        return _homeRoute();
      case RoutesNames.chatScreen:
        return _chatRoute();
      case RoutesNames.onboardingScreen:
        return _onBoardingRoute();
      case RoutesNames.callsScreen:
        return _callsRoute();
      case RoutesNames.settingsScreen:
        return _settingsRoute();
      case RoutesNames.tabsScreen:
        return _tabsRoute();
      case RoutesNames.searchBarScreen:
        return _searchRoute();
      case RoutesNames.varificationScreen:
        return _varifyRoute();
      case RoutesNames.contactsScreen:
        return _contactsRoute();

      default:
        return _defaultRoute();
    }
  }

  static _spashRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const SplashScreen(),
    );
  }

  static _loginRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AuthScreenn(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutExpo;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(seconds: 2), // Add this line
    );
  }

  static _homeRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const HomeScreen(),
    );
  }

  static _callsRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const CallsScreen(),
    );
  }

  static _tabsRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const BottomTabs(),
    );
  }

  static _searchRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const SearchBarScreen(),
    );
  }

  static _settingsRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const SettingsScreen(),
    );
  }

  static _chatRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const ChatScreen(),
    );
  }

  static _varifyRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const VarificationScreen(),
    );
  }

  static _contactsRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => const ContactsScreen(),
    );
  }

  static _onBoardingRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const OnboardingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutExpo;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(seconds: 2), // Add this line
    );
  }

  static _defaultRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => const Scaffold(
              body: Center(
                child: Text("Route not defined"),
              ),
            ));
  }
}
