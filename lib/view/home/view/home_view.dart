import 'package:flutter/material.dart';
import 'package:memo_notes/product/widget/tab/appbar_tabs.dart';
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
  late List<Widget> tabs;
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    tabs = AppbarTabs().tabs;
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.animation!.addListener(() {
      setState(() {
        _currentIndex = (_tabController.animation!.value).round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: tabController,
      ),
      floatingActionButton: _floatingActionButton,
    );
  }

  Future<bool> _onWillPop() {
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
      length: tabs.length,
      child: Scaffold(
        backgroundColor: context.colorScheme.primary,
        appBar: AppBar(
          centerTitle: true,
          title: TabBar(
            labelPadding: context.horizontalPaddingLow,
            controller: _tabController,
            tabs: tabs,
          ),
        ),
        body: Container(
          color: context.colorScheme.primary,
          child: Center(
            child: TabBarView(
              controller: _tabController,
              children: const [
                CounterPage(),
                CountdownPage(),
                TodoPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material get _floatingActionButton {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(1000.0),
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
