import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product/widget/buttonfields/counter_button.dart';

import '../../../../core/components/card/error_widget.dart';
import '../../../../core/extension/context_extension.dart';
import '../cubit/counter_cubit.dart';
import '../model/counter_model.dart';

class CounterView extends StatefulWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  @override
  Widget build(BuildContext context) {
    List<CounterModel?> counterList = [];
    return BlocBuilder<CounterCubit, CounterState>(
      builder: (context, state) {
        if (state is CounterListLoadSuccess) {
          counterList = state.counterList;
        } else if (state is CounterLoadInProgress) {
          const CircularProgressIndicator();
        } else if (state is CounterLoadFailure) {
          ErrorCard(error: 'CounterLoadFailure  => ${state.e}');
        }
        return ListView(
          children: [
            context.emptySizedHeightBoxLow,
            for (var i = 0; i < counterList.length; i++)
              CounterField(
                model: counterList[i]!,
              ),
            context.emptySizedHeightBoxHigh,
            context.emptySizedHeightBoxHigh,
          ],
        );
      },
    );
  }
}
