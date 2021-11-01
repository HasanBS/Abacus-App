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

  Map<String, dynamic> toMap() {
    return {
      'isFirstApp': isFirstApp,
    };
  }

  factory SplashState.fromMap(Map<String, dynamic> map) {
    return SplashState(
      isFirstApp: map['isFirstApp'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SplashState.fromJson(String source) =>
      SplashState.fromMap(json.decode(source) as Map<String, dynamic>);
}
