import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:memo_notes/core/constants/app/app_constants.dart';
import 'package:meta/meta.dart';

import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/init/navigation/navigation_service.dart';
import '../service/splash_service.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> with HydratedMixin {
  SplashService service;
  SplashBloc(
    this.service,
  ) : super(SplashState.initial());

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is NavigateToHomeScreenEvent) {
      if (!state.isFirstApp) {
        yield state.copyWith(isFirstApp: true);
        await _splashDuration();
        await NavigationService.instance.navigateToPageClear(path: NavigationConstants.ONBOARDPAGE);
        return;
      }
      await _splashDuration();
      await NavigationService.instance.navigateToPageClear(path: NavigationConstants.HOME);
    }
  }

  Future<void> _splashDuration() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.SPLASH_ANIMATION_DURATION));
  }

  @override
  SplashState fromJson(Map<String, dynamic> json) {
    return SplashState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(SplashState state) {
    return state.toJson();
  }
}
