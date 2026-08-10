import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/network_info_service.dart';

sealed class ConnectivityState {
  const ConnectivityState();
}

class ConnectivityOnline extends ConnectivityState {
  const ConnectivityOnline();
}

class ConnectivityOffline extends ConnectivityState {
  final ConnectionStatus status;
  const ConnectivityOffline(this.status);
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final NetworkInfoService _networkInfo;

  ConnectivityCubit(this._networkInfo) : super(const ConnectivityOnline());

  /// Called by feature Cubits whenever a [ConnectionFailure] is detected.
  void markOffline(ConnectionStatus status) {
    if (state is! ConnectivityOffline) {
      emit(ConnectivityOffline(status));
    }
  }

  /// Re-checks connectivity. Emits [ConnectivityOnline] if resolved.
  Future<void> retry() async {
    final status = await _networkInfo.checkConnectivity();
    if (isClosed) return;
    if (status == ConnectionStatus.connected) {
      emit(const ConnectivityOnline());
    } else {
      emit(ConnectivityOffline(status));
    }
  }
}
