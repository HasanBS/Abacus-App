import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/extension/string_extension.dart';
import '../../../core/constants/image/image_constatns.dart';
import '../../../core/init/lang/locale_keys.g.dart';
import '../model/onboard_model.dart';

part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(OnboardIntial()) {
    onBoardItems.add(OnBoardModel(
        title: LocaleKeys.onBoard_page1_title.locale,
        description: LocaleKeys.onBoard_page1_description.locale,
        imagePath: ImageConstants.instance.onboardAdd));
    onBoardItems.add(OnBoardModel(
        title: LocaleKeys.onBoard_page2_title.locale,
        description: LocaleKeys.onBoard_page2_description.locale,
        imagePath: ImageConstants.instance.onboardDelete));
    onBoardItems.add(OnBoardModel(
        title: LocaleKeys.onBoard_page3_title.locale,
        description: LocaleKeys.onBoard_page3_description.locale,
        imagePath: ImageConstants.instance.onboardFinish));

    emit(OnboardLoad(onBoardItems, currentIndex));
  }

  List<OnBoardModel> onBoardItems = [];

  int currentIndex = 0;

  void changeCurrentIndex(int value) {
    currentIndex = value;
    emit(OnboardLoad(onBoardItems, currentIndex));
  }
}
