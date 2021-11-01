part of 'onboard_cubit.dart';

@immutable
abstract class OnboardState {
  const OnboardState();
}

class OnboardIntial extends OnboardState {}

class OnboardLoad extends OnboardState {
  final List<OnBoardModel> onBoardItems;
  final int currentIndex;
  const OnboardLoad(this.onBoardItems, this.currentIndex);
}
