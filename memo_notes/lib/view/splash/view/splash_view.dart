import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/lottie/lottie_widget.dart';
import '../../../core/constants/image/image_constatns.dart';
import '../../../core/extension/context_extension.dart';
import '../bloc/splash_bloc.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  BlocProvider<SplashBloc> _buildBody(BuildContext context) {
    return BlocProvider(
        create: (context) => SplashBloc()..add(NavigateToHomeScreenEvent()),
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            return buildScaffoldBody(context);
          },
        ));
  }

  Scaffold buildScaffoldBody(BuildContext context) {
    return Scaffold(
        body: Container(
      color: context.colorScheme.primary,
      child: SafeArea(
        child: Stack(
          children: [
            buildAnimatedLottie(context),
          ],
        ),
      ),
    ));
  }

  Widget buildAnimatedLottie(BuildContext context) {
    return AnimatedAlign(
      alignment: Alignment.center,
      duration: context.durationSlow,
      child: LottieWidget(
        path: context.isDarkTheme
            ? ImageConstants.instance.iconMotionDarkLoti
            : ImageConstants.instance.iconMotionLightLoti,
        repeat: false,
      ),
    );
  }
}
