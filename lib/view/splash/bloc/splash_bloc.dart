import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/init/navigation/navigation_service.dart';
import '../service/splash_service.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> with HydratedMixin {
  SplashBloc() : super(SplashState.initial());

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is NavigateToHomeScreenEvent) {
      SplashService.instance.serviceInit();
      if (!state.isFirstApp) {
        yield state.copyWith(isFirstApp: true);
        await Future.delayed(const Duration(milliseconds: 1250));
        await NavigationService.instance.navigateToPageClear(path: NavigationConstants.ONBOARDPAGE);
      } else {
        await Future.delayed(const Duration(milliseconds: 1250));
        await NavigationService.instance.navigateToPageClear(path: NavigationConstants.HOME);
      }
    }
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
