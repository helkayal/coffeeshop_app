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
  final bool fromFavorites;
  const CustomizationRoute({this.product, this.fromFavorites = false});
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

  ShellState copyWith({int? tabIndex, List<SecondaryRoute>? secondaryStack}) =>
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

  /// Called by screens that need to intercept back navigation.
  /// Return [true] to allow navigation, [false] to block it.
  Future<bool> Function()? onWillPopSecondary;

  /// Select a bottom-nav tab. Checks [onWillPopSecondary] first.
  Future<void> selectTab(int index) async {
    if (onWillPopSecondary != null) {
      final allow = await onWillPopSecondary!();
      if (!allow) return;
    }
    onWillPopSecondary = null;
    emit(state.copyWith(tabIndex: index, secondaryStack: const []));
  }

  void pushSecondary(SecondaryRoute route) =>
      emit(state.copyWith(secondaryStack: [...state.secondaryStack, route]));

  /// Pop the top secondary screen (no interception — caller handles it).
  void popSecondary() {
    if (state.secondaryStack.isEmpty) return;
    onWillPopSecondary = null;
    final stack = [...state.secondaryStack]..removeLast();
    emit(state.copyWith(secondaryStack: stack));
  }

  /// Pop with interception — used by the AppBar back button.
  Future<void> popSecondaryWithCheck() async {
    if (state.secondaryStack.isEmpty) return;
    if (onWillPopSecondary != null) {
      final allow = await onWillPopSecondary!();
      if (!allow) return;
    }
    onWillPopSecondary = null;
    final stack = [...state.secondaryStack]..removeLast();
    emit(state.copyWith(secondaryStack: stack));
  }

  /// Replace the entire secondary stack with a single route.
  void clearAndPush(SecondaryRoute route) {
    onWillPopSecondary = null;
    emit(state.copyWith(secondaryStack: [route]));
  }
}
