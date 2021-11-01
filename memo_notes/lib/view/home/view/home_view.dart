import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memo_notes/core/components/popup/todo_popup_view.dart';
import 'package:memo_notes/view/home/todo/view/todo_view.dart';

import '../../../core/components/popup/countdown_popup.dart';
import '../../../core/components/popup/counter_popup.dart';
import '../../../core/components/text/auto_locale_text.dart';
import '../../../core/constants/image/image_constatns.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../../components/hero_dialog_route.dart';
import '../countdown/view/countdown_view.dart';
import '../counter/view/counter_view.dart';

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
        value: "Todo",
      ),
    ),
  ];
  late TabController _tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.animation!.addListener(() {
      //! ..
      setState(() {
        _currentIndex = (_tabController.animation!.value)
            .round(); //_tabController.animation.value returns double
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: tabController(),
      ),
      floatingActionButton: floatingActionButton(context),
    );
  }

  Future<bool> onWillPop() {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: AutoLocaleText(
          value: LocaleKeys.home_closeSnackBarMessenge,
        )
            // Text(
            //   LocaleKeys.home_closeSnackBarMessenge.locale,
            // ),
            ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  DefaultTabController tabController() {
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

  Material floatingActionButton(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //Makes it usable on any background color
      child: InkWell(
        //This keeps the splash effect within the circle
        borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (_) {
            switch (_currentIndex) {
              case 0:
                return const CounterPopup(
                  heroAddTodo: 'Create-Counter',
                );
              case 1:
                return const CountdownPopup(
                  heroAddTodo: 'Create-Countdown',
                );
              case 2:
                return TodoPopup(
                  heroAddTodo: 'Create-Todo',
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
