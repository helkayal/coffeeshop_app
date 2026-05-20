import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState {
  final int tabIndex;
  final List<Widget> secondaryStack;

  const HomeState({this.tabIndex = 0, this.secondaryStack = const []});

  bool get hasSecondary => secondaryStack.isNotEmpty;
  Widget? get currentSecondary => hasSecondary ? secondaryStack.last : null;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectTab(int index) => emit(HomeState(tabIndex: index));

  void pushSecondary(Widget body) {
    emit(HomeState(
      tabIndex: state.tabIndex,
      secondaryStack: [...state.secondaryStack, body],
    ));
  }

  void popSecondary() {
    if (state.secondaryStack.isEmpty) return;
    final stack = [...state.secondaryStack]..removeLast();
    emit(HomeState(tabIndex: state.tabIndex, secondaryStack: stack));
  }
}
