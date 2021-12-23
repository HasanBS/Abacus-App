import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product/widget/buttonfields/countdown_button.dart';
import '../../../../core/components/card/error_widget.dart';
import '../cubit/countdown_cubit.dart';
import '../model/countdown_model.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountdownCubit, CountdownState>(
      builder: (context, state) {
        if (state is CountdownListLoadSuccess) {
          return CountdownView(countdownList: state.countdownList);
        } else if (state is CountdownLoadInProgress) {
          return const CircularProgressIndicator();
        } else if (state is CountdownLoadFailure) {
          return ErrorCard(error: 'CountdownLoadFailure  => ${state.e}');
        }
        return const SizedBox();
      },
    );
  }
}

class CountdownView extends StatelessWidget {
  final List<CountdownModel> countdownList;

  const CountdownView({Key? key, required this.countdownList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: countdownList.length,
        itemBuilder: (context, index) {
          return CountdownField(model: countdownList[index]);
        });
  }
}
