import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product/widget/buttonfields/counter_button.dart';
import '../../../../core/components/card/error_widget.dart';
import '../cubit/counter_cubit.dart';
import '../model/counter_model.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterCubit, CounterState>(
      builder: (context, state) {
        if (state is CounterListLoadSuccess) {
          return CounterView(counterList: state.counterList);
        } else if (state is CounterLoadInProgress) {
          return const CircularProgressIndicator();
        } else if (state is CounterLoadFailure) {
          return ErrorCard(error: 'CounterLoadFailure  => ${state.e}');
        }
        return Container();
      },
    );
  }
}

class CounterView extends StatelessWidget {
  final List<CounterModel> counterList;
  const CounterView({Key? key, required this.counterList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: counterList.length,
        itemBuilder: (context, index) {
          return CounterField(
            model: counterList[index],
          );
        });
  }
}
