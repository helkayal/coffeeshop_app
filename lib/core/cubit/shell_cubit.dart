import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/menu/domain/entities/product.dart';

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
  final Product? product;
  const CustomizationRoute({this.product});
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
  final String orderId;
  const OrderConfirmationRoute({required this.orderId});
}

class ViewBenefitsRoute extends SecondaryRoute {
  const ViewBenefitsRoute();
}

class ReferralRoute extends SecondaryRoute {
  const ReferralRoute();
}

class PaymentMethodsRoute extends SecondaryRoute {
  const PaymentMethodsRoute();
}

class LoyaltyHistoryRoute extends SecondaryRoute {
  const LoyaltyHistoryRoute();
}

class WalletRoute extends SecondaryRoute {
  const WalletRoute();
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

  ShellState copyWith({
    int? tabIndex,
    List<SecondaryRoute>? secondaryStack,
  }) =>
      ShellState(
        tabIndex: tabIndex ?? this.tabIndex,
        secondaryStack: secondaryStack ?? this.secondaryStack,
      );
}

// ---------------------------------------------------------------------------
// Cubit — manages the entire app shell (tab + in-shell back-stack).
// ---------------------------------------------------------------------------

class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

  /// Select a bottom-nav tab and clear any open secondary screens.
  void selectTab(int index) =>
      emit(state.copyWith(tabIndex: index, secondaryStack: const []));

  void pushSecondary(SecondaryRoute route) =>
      emit(state.copyWith(secondaryStack: [...state.secondaryStack, route]));

  void popSecondary() {
    if (state.secondaryStack.isEmpty) return;
    final stack = [...state.secondaryStack]..removeLast();
    emit(state.copyWith(secondaryStack: stack));
  }

  /// Replace the entire secondary stack with a single route.
  /// Used for terminal flows like Order Confirmation where going
  /// back to Payment makes no sense.
  void clearAndPush(SecondaryRoute route) =>
      emit(state.copyWith(secondaryStack: [route]));
}
