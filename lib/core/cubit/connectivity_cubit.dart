import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/connection_status.dart';
import '../services/network_info_service.dart';

sealed class ConnectivityState {
  const ConnectivityState();
}

class ConnectivityOnline extends ConnectivityState {
  const ConnectivityOnline();
}

class ConnectivityChecking extends ConnectivityState {
  const ConnectivityChecking();
}

class ConnectivityOffline extends ConnectivityState {
  final ConnectionStatus status;
  const ConnectivityOffline(this.status);
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final NetworkInfoService _networkInfo;

  ConnectivityCubit(this._networkInfo) : super(const ConnectivityChecking());

  /// Called by feature Cubits whenever a [ConnectionFailure] is detected.
  void markOffline(ConnectionStatus status) {
    if (state is! ConnectivityOffline) {
      emit(ConnectivityOffline(status));
    }
  }

  /// Re-checks connectivity. Emits [ConnectivityOnline] if resolved.
  Future<void> check() async {
    emit(const ConnectivityChecking());
    final status = await _networkInfo.checkConnectivity();
    if (isClosed) return;
    if (status == ConnectionStatus.connected) {
      emit(const ConnectivityOnline());
    } else {
      emit(ConnectivityOffline(status));
    }
  }

  Future<void> retry() => check();
}
