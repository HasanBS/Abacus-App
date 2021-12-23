import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/image/image_constatns.dart';
import '../../../../../core/extension/context_extension.dart';
import '../../../../../product/widget/button/counter_button.dart';
import '../../cubit/counter_cubit.dart';
import '../../model/counter_model.dart';

class BottomButtons extends StatelessWidget {
  final CounterModel model;
  const BottomButtons({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: _decreaseButtton(context)),
          SizedBox(
            height: context.dynamicHeight(0.2),
            child: VerticalDivider(
              color: context.colorScheme.secondary,
              thickness: 0.5,
              width: 0,
            ),
          ),
          Flexible(child: _increaseButton(context)),
        ],
      ),
    );
  }

  ElevatedButton _decreaseButtton(BuildContext context) {
    return CounterButton(
      context: context,
      iconData: ImageConstants.instance.minusIcon,
      onPressed: () {
        model.counterTotal -= model.counterRatio;
        context.read<CounterCubit>().updateCounter(model);
      },
    );
  }

  ElevatedButton _increaseButton(BuildContext context) {
    return CounterButton(
      context: context,
      iconData: ImageConstants.instance.plusIcon,
      onPressed: () {
        model.counterTotal += model.counterRatio;
        context.read<CounterCubit>().updateCounter(model);
      },
    );
  }
}
