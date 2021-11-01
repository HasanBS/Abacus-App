// import 'package:bloc_architecture_app/logic/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_notes/core/extension/context_extension.dart';
import 'package:memo_notes/view/home/counter/cubit/counter_cubit.dart';
import 'package:memo_notes/view/home/counter/model/counter_action_model.dart';
import 'package:memo_notes/view/home/counter/model/counter_model.dart';

class CounterSlider extends StatefulWidget {
  final CounterModel counterModel;

  const CounterSlider({
    Key? key,
    required this.counterModel,
  }) : super(key: key);

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<CounterSlider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late double _startAnimationPosX;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    _animation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 0.0)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CounterSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 0.0)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: context.dynamicWidth(0.55),
        height: context.dynamicHeight(0.1),
        child: Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(60.0),
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 10.0,
                child: Icon(
                  Icons.remove,
                  size: context.dynamicWidth(0.1),
                  //color: Theme.of(context).iconTheme.color.withOpacity(0.7), //TODO
                ),
              ),
              Positioned(
                right: 10.0,
                child: Icon(
                  Icons.add,
                  size: context.dynamicWidth(0.1),
                  //color: Theme.of(context).iconTheme.color.withOpacity(0.7), //TODO
                ),
              ),
              GestureDetector(
                onHorizontalDragStart: _onPanStart,
                onHorizontalDragUpdate: _onPanUpdate,
                onHorizontalDragEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation as Animation<Offset>,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Theme.of(context).accentColor,
                      shape: const CircleBorder(),
                      elevation: 5.0,
                      child: Center(
                        child: Icon(
                          Icons.trip_origin,
                          size: context.dynamicWidth(0.1),
                          // color: Theme.of(context)
                          //     .iconTheme
                          //     .color
                          //     .withOpacity(0.6), //TODO
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    final box = context.findRenderObject()! as RenderBox;
    final local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;

    return ((local.dx * 0.75) / box.size.width) - 0.4;
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();

    if (_controller.value <= -0.20) {
      widget.counterModel.counterTotal -= widget.counterModel.counterRatio;
      context.read<CounterCubit>().insertActionUpdateModel(
          CounterActionModel(
              counterId: widget.counterModel.id!,
              isPositive: 0,
              actionTotal: widget.counterModel.counterTotal,
              actionAmount: widget.counterModel.counterRatio),
          widget.counterModel);
    } else if (_controller.value >= 0.20) {
      widget.counterModel.counterTotal += widget.counterModel.counterRatio;
      context.read<CounterCubit>().insertActionUpdateModel(
          CounterActionModel(
              counterId: widget.counterModel.id!,
              isPositive: 1,
              actionTotal: widget.counterModel.counterTotal,
              actionAmount: widget.counterModel.counterRatio),
          widget.counterModel);
    }

    final SpringDescription _kDefaultSpring = SpringDescription.withDampingRatio(
      mass: 0.9,
      stiffness: 250.0,
      ratio: 0.6,
    );

    _controller.animateWith(SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
  }
}
