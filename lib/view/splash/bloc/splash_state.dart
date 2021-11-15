part of 'splash_bloc.dart';

@immutable
class SplashState extends Equatable {
  final bool isFirstApp;

  const SplashState({
    required this.isFirstApp,
  });

  factory SplashState.initial() {
    return const SplashState(isFirstApp: false);
  }
  @override
  List<Object> get props => [isFirstApp];

  SplashState copyWith({
    bool? isFirstApp,
  }) {
    return SplashState(
      isFirstApp: isFirstApp ?? this.isFirstApp,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'isFirstApp': isFirstApp,
    };
  }

  factory SplashState.fromJson(Map<String, dynamic> map) {
    return SplashState(
      isFirstApp: map['isFirstApp'] as bool,
    );
  }
}
