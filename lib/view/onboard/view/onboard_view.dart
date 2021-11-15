import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/image/image_constatns.dart';
import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/init/navigation/navigation_service.dart';
import '../cubit/onboard_cubit.dart';
import '../model/onboard_model.dart';

class OnBoardView extends StatelessWidget {
  const OnBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardCubit(),
      child: Scaffold(
        body: Padding(
          padding: context.horizontalPaddingMedium,
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                  flex: 5,
                  child: BlocBuilder<OnboardCubit, OnboardState>(
                    builder: (context, state) {
                      if (state is OnboardLoad) {
                        return PageView.builder(
                          itemCount: state.onBoardItems.length,
                          onPageChanged: (value) {
                            context.read<OnboardCubit>().changeCurrentIndex(value);
                          },
                          itemBuilder: (context, index) =>
                              _buildColumnBody(state.onBoardItems[index], context),
                        );
                      }
                      return Container();
                    },
                  )),
              Expanded(flex: 2, child: _buildRowFooter(context)),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildColumnBody(OnBoardModel onBoardItem, BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 4, child: SvgPicture.asset(onBoardItem.imagePath)),
        _buildColumnDescription(onBoardItem, context),
      ],
    );
  }

  Column _buildColumnDescription(OnBoardModel onBoardItem, BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          onBoardItem.title,
          textAlign: TextAlign.center,
          style: context.textTheme.headline3!.copyWith(fontSize: 60, fontWeight: FontWeight.w300),
        ),
        Padding(
          padding: context.verticalPaddingNormal,
          child: AutoSizeText(
            onBoardItem.description,
            textAlign: TextAlign.center,
            style: context.textTheme.headline6,
          ),
        ),
      ],
    );
  }

  Row _buildRowFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildListViewCircles(context),
        _buildFloatingActionButtonSkip(context),
      ],
    );
  }

  BlocBuilder _buildListViewCircles(BuildContext context) {
    return BlocBuilder<OnboardCubit, OnboardState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: context.paddingLow,
              child: CircleAvatar(
                backgroundColor: context.read<OnboardCubit>().currentIndex == index
                    ? context.colorScheme.secondary
                    : context.colorScheme.secondary.withOpacity(0.5),
                radius: context.read<OnboardCubit>().currentIndex == index
                    ? context.dynamicWidth(0.015)
                    : context.dynamicWidth(0.01),
              ),
            );
          },
        );
      },
    );
  }

  Material _buildFloatingActionButtonSkip(BuildContext context) {
    return Material(
      type: MaterialType.transparency, //Makes it usable on any background color
      child: InkWell(
        //This keeps the splash effect within the circle
        borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
        onTap: () {
          NavigationService.instance.navigateToPageClear(path: NavigationConstants.HOME);
        },
        child: Padding(
          padding: context.paddingNormal,
          child: Icon(
            ImageConstants.instance.rightChevron,
            size: 50.0,
            color: context.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
