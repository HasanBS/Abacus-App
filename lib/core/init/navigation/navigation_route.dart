import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../view/home/countdown/model/countdown_model.dart';
import '../../../view/home/countdown/view/countdown_page_view.dart';
import '../../../view/home/counter/model/counter_model.dart';
import '../../../view/home/counter/view/counter_page_view.dart';
import '../../../view/home/view/home_view.dart';
import '../../../view/onboard/view/onboard_view.dart';
import '../../../view/splash/view/splash_view.dart';
import '../../components/card/not_found_navigation_widget.dart';
import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.DEFAULT:
        return normalNavigate(const SplashView());

      case NavigationConstants.HOME:
        return normalNavigate(const HomeView());

      case NavigationConstants.COUNTERPAGE:
        return normalNavigate(CounterPageView(
          model: args.arguments! as CounterModel,
        ));
      case NavigationConstants.COUNTDOWNPAGE:
        return normalNavigate(CountdownPageView(model: args.arguments! as CountdownModel));

      case NavigationConstants.ONBOARDPAGE:
        return normalNavigate(const OnBoardView());
      default:
        return MaterialPageRoute(
          builder: (context) => NotFoundNavigationWidget(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
