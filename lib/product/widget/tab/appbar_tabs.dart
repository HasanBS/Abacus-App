import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:memo_notes/core/extension/string_extension.dart';
import 'package:memo_notes/core/init/lang/locale_keys.g.dart';

class AppbarTabs {
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  late List<Widget> tabs = <Widget>[
    Tab(
      child: AutoSizeText(
        LocaleKeys.counter_homeScreenTitle.locale,
        maxLines: 1,
        group: _autoSizeGroup,
      ),
    ),
    Tab(
      child: AutoSizeText(
        LocaleKeys.countdown_homeScreenTitle.locale,
        maxLines: 1,
        group: _autoSizeGroup,
      ),
    ),
    Tab(
      child: AutoSizeText(
        LocaleKeys.todo_todoTitle.locale,
        maxLines: 1,
        group: _autoSizeGroup,
      ),
    ),
  ];
}
