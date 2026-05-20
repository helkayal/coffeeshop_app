import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SecondaryRoute {
  const SecondaryRoute();
}

class CartRoute extends SecondaryRoute {
  const CartRoute();
}

class PaymentRoute extends SecondaryRoute {
  const PaymentRoute();
}

class CustomizationRoute extends SecondaryRoute {
  const CustomizationRoute();
}

class SettingsRoute extends SecondaryRoute {
  const SettingsRoute();
}

class HomeState {
  final int tabIndex;
  final List<SecondaryRoute> secondaryStack;

  const HomeState({this.tabIndex = 0, this.secondaryStack = const []});

  bool get hasSecondary => secondaryStack.isNotEmpty;
  SecondaryRoute? get currentSecondary => hasSecondary ? secondaryStack.last : null;
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectTab(int index) => emit(HomeState(tabIndex: index));

  void pushSecondary(SecondaryRoute route) {
    emit(HomeState(
      tabIndex: state.tabIndex,
      secondaryStack: [...state.secondaryStack, route],
    ));
  }

  void popSecondary() {
    if (state.secondaryStack.isEmpty) return;
    final stack = [...state.secondaryStack]..removeLast();
    emit(HomeState(tabIndex: state.tabIndex, secondaryStack: stack));
  }
}
