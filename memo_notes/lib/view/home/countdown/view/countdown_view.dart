import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/button/countdown_button.dart';
import '../../../../core/extension/context_extension.dart';
import '../cubit/countdown_cubit.dart';
import '../model/countdown_model.dart';

class CountdownView extends StatelessWidget {
  const CountdownView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CountdownModel?> countdownList = [];
    return BlocBuilder<CountdownCubit, CountdownState>(
      builder: (context, state) {
        if (state is CountdownListLoadSuccess) {
          print("CountdownListLoadSuccess");
          countdownList = state.countdownList;
        } else if (state is CountdownLoadInProgress)
          print("CountdownLoadInProgress");
        else if (state is CountdownLoadFailure) print("CountdownLoadFailure  => ${state.e}");

        return ListView(
          children: [
            context.emptySizedHeightBoxLow,
            for (var i = 0; i < countdownList.length; i++)
              CountdownField(
                model: countdownList[i]!,
              ),
            context.emptySizedHeightBoxHigh,
            context.emptySizedHeightBoxHigh,
          ],
        );

        // return ListView.builder(
        //     itemCount: countdownList.length,
        //     itemBuilder: (BuildContext context, int index) {

        //       return CountdownField(
        //         model: countdownList[index]!,
        //       );
        //     });
      },
    );
  }
}
