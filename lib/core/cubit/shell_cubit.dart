import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------------------------------------------------------
// Secondary route definitions — one sealed type per in-shell destination.
// ---------------------------------------------------------------------------

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

class EditProfileRoute extends SecondaryRoute {
  const EditProfileRoute();
}

class OrdersHistoryRoute extends SecondaryRoute {
  const OrdersHistoryRoute();
}

class OrderConfirmationRoute extends SecondaryRoute {
  const OrderConfirmationRoute();
}

class ViewBenefitsRoute extends SecondaryRoute {
  const ViewBenefitsRoute();
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class ShellState {
  final int tabIndex;
  final List<SecondaryRoute> secondaryStack;

  const ShellState({this.tabIndex = 0, this.secondaryStack = const []});

  bool get hasSecondary => secondaryStack.isNotEmpty;
  SecondaryRoute? get currentSecondary =>
      hasSecondary ? secondaryStack.last : null;

  /// True when any checkout-related route is already in the stack.
  /// Used to decide whether to show the cart icon in the app bar.
  bool get isInCartFlow => secondaryStack.any((r) => r is CartRoute);
}

// ---------------------------------------------------------------------------
// Cubit — manages the entire app shell (tab + in-shell back-stack).
// Kept in core/ because it is app-wide, not home-feature-specific.
// ---------------------------------------------------------------------------

class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

  /// Select a bottom-nav tab. Always clears the secondary stack so the user
  /// sees the raw tab screen, not a lingering secondary overlay.
  void selectTab(int index) =>
      emit(ShellState(tabIndex: index, secondaryStack: const []));

  void pushSecondary(SecondaryRoute route) {
    emit(ShellState(
      tabIndex: state.tabIndex,
      secondaryStack: [...state.secondaryStack, route],
    ));
  }

  void popSecondary() {
    if (state.secondaryStack.isEmpty) return;
    final stack = [...state.secondaryStack]..removeLast();
    emit(ShellState(tabIndex: state.tabIndex, secondaryStack: stack));
  }

  void clearAndPush(SecondaryRoute route) {
    emit(ShellState(tabIndex: state.tabIndex, secondaryStack: [route]));
  }
}
