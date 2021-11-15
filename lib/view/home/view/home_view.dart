import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../product/widget/popup/countdown_popup.dart';
import '../../../product/widget/popup/counter_popup.dart';
import '../../../product/widget/popup/todo_popup_view.dart';

import '../../../core/components/text/auto_locale_text.dart';
import '../../../core/constants/app/app_constants.dart';
import '../../../core/constants/image/image_constatns.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../../components/hero_dialog_route.dart';
import '../countdown/view/countdown_view.dart';
import '../counter/view/counter_view.dart';
import '../todo/view/todo_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  DateTime? currentBackPressTime;
  List<Tab> tabs = <Tab>[
    const Tab(
      child: AutoLocaleText(
        value: LocaleKeys.counter_homeScreenTitle,
      ),
    ),
    const Tab(
      child: AutoLocaleText(
        value: LocaleKeys.countdown_homeScreenTitle,
      ),
    ),
    const Tab(
      child: AutoLocaleText(
        value: LocaleKeys.todo_todoTitle,
      ),
    ),
  ];

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.animation!.addListener(() {
      setState(() {
        _currentIndex = (_tabController.animation!.value)
            .round(); //_tabController.animation.value returns double
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: tabController,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Future<bool> onWillPop() {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            const Duration(seconds: AppConstants.CLOSESNACKBARDURATION)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AutoLocaleText(
            value: LocaleKeys.home_closeSnackBarMessenge,
          ),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  DefaultTabController get tabController {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.colorScheme.primary,
        appBar: AppBar(
          centerTitle: true,
          title: TabBar(
            labelPadding: context.horizontalPaddingMedium,
            controller: _tabController,
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: Container(
          color: context.colorScheme.primary,
          child: TabBarView(
            controller: _tabController,
            children: const [
              CounterView(),
              CountdownView(),
              TodoView(),
            ],
          ),
        ),
      ),
    );
  }

  Material get floatingActionButton {
    return Material(
      type: MaterialType.transparency, //Makes it usable on any background color
      child: InkWell(
        //This keeps the splash effect within the circle
        borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (_) {
            switch (_currentIndex) {
              case 0:
                return CounterPopup(
                  heroAddTodo: AppConstants.COUNTERHEROTAG,
                );
              case 1:
                return const CountdownPopup(
                  heroAddTodo: AppConstants.COUNTDOWNHEROTAG,
                );
              case 2:
                return TodoPopup(
                  heroAddTodo: AppConstants.TODOHEROTAG,
                );
              default:
                return Container();
            }
          }));
        },
        child: Padding(
          padding: context.paddingNormal,
          child: Icon(
            ImageConstants.instance.plusIcon,
            size: 50.0,
            color: context.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
